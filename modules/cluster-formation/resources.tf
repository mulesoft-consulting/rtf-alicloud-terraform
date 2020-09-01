resource "random_string" "cluster_token" {
  length  = 16
  special = false
}

# VPC
resource "alicloud_vpc" "vpc" {
  name           = "${var.cluster_name}-vpc"
  cidr_block     = var.vpc_cidr
  count          = var.existing_vpc_id != "" ? 0 : 1
}

# SUBNET
resource "alicloud_vswitch" "public" {
  vpc_id            = alicloud_vpc.vpc[0].id
  cidr_block        = cidrsubnet(
    var.vpc_cidr,
    24 - replace(var.vpc_cidr, "/[^/]*[/]/", ""),
    count.index,
  )

  count             = var.existing_vpc_id != "" ? 0 : length(lookup(var.available_zones, var.region, data.alicloud_zones.available.zones[*].id))
  availability_zone = element(
    lookup(
      var.available_zones, 
      var.region, 
      data.alicloud_zones.available.zones[*].id
    ), 
    count.index
  )

  tags = {
    Name = "${var.cluster_name}-subnet"
    ROLE = var.role_tag_value
  }
  
}

# ROUTE TABLE FOR THE VPC
resource "alicloud_route_table" "rt" {
  vpc_id      = alicloud_vpc.vpc[0].id
  count       = var.existing_vpc_id != "" ? 0 : 1
  name        = "${var.cluster_name}-rt"
}

# RT Association to Subnet
resource "alicloud_route_table_attachment" "rta" {
  count          = length(alicloud_vswitch.public)
  vswitch_id     = element(alicloud_vswitch.public[*].id, count.index)
  route_table_id = alicloud_route_table.rt[0].id
}

# ECS INSTANCES KEY PAIR
resource "alicloud_key_pair" "key"{
  key_name  = var.key_pair
  public_key = var.public_key
}

/** 
  TODO: Create The corresponding elements in alicloud
  resource "aws_eip" "nat" {
    count = var.enable_nat_gateways == "true" ? length(data.aws_availability_zones.available.names) : 0
    vpc   = true

    lifecycle {
      create_before_destroy = true
    }
  }

  resource "aws_nat_gateway" "ngw" {
    count         = var.enable_nat_gateways == "true" ? length(data.aws_availability_zones.available.names) : 0
    allocation_id = element(aws_eip.nat[*].id, count.index)
    subnet_id     = element(aws_subnet.public[*].id, count.index)
    depends_on    = [aws_subnet.public]

    tags = {
      Name = "${var.cluster_name}-ngw"
      ROLE = var.role_tag_value
    }

    lifecycle {
      create_before_destroy = true
    }
  }
*/


locals {
  root_volume_type = "cloud_essd"
  root_volume_size = "90"

  gravity_volume_type                            = "cloud_essd"
  gravity_volume_size                            = "250"
  #gravity_volume_size_inbound_traffic_controller = "50"
  gravity_volume_device_name                     = "/dev/xvdb"

  etcd_volume_type = "cloud_essd"
  #etcd_volume_iops = "3000"
  etcd_volume_size = "60"
  etcd_device_name = "/dev/xvdc"

  volume_delete_on_termination = true

  #lb_subnet_mappings = concat(var.existing_subnet_ids, alicloud_instance.installer_node[*].subnet_id, alicloud_instance.controller_node[*].subnet_id)
}

resource "alicloud_instance" "installer_node" {
  image_id                      = data.alicloud_images.nodes.images[0].id
  instance_type                 = var.instance_type_controller
  internet_max_bandwidth_out    = var.enable_public_ips ? var.node_max_bandwidth : 0
  vswitch_id                    = element(concat(var.existing_subnet_ids, alicloud_vswitch.public[*].id), 0)
  security_groups               = [alicloud_security_group.cluster.id]
  instance_name                 = "${var.cluster_name}-controller"
  
  key_name  = var.key_pair
  count     = 1

  tags = {
    Name = "${var.cluster_name}-controller"
    ROLE = var.role_tag_value
  }

  volume_tags = {
    Name = "${var.cluster_name}-volume"
    ROLE = var.role_tag_value
  }

  user_data = data.template_cloudinit_config.installer.rendered

  system_disk_category  = local.root_volume_type
  system_disk_size      = local.root_volume_size

  # gravity/docker data device
  data_disks {
    category              = local.gravity_volume_type
    name                  = local.gravity_volume_device_name
    size                  = local.gravity_volume_size
    delete_with_instance  = local.volume_delete_on_termination
  }

  # etcd device
  data_disks {
    category              = local.etcd_volume_type
    name                  = local.etcd_device_name
    size                  = local.etcd_volume_size
    delete_with_instance = local.volume_delete_on_termination
  }
}


resource "alicloud_instance" "controller_node" {
  image_id                      = data.alicloud_images.nodes.images[0].id
  instance_type                 = var.instance_type_controller
  internet_max_bandwidth_out    = var.enable_public_ips ? var.node_max_bandwidth : 0
  security_groups               = [alicloud_security_group.cluster.id]
  instance_name                 = "${var.cluster_name}-controller-${count.index}"

  vswitch_id                    = element(
    concat(var.existing_subnet_ids, alicloud_vswitch.public[*].id),
    count.index + 1,
  )

  key_name = var.key_pair
  count    = var.controllers - 1

  tags = {
    Name = "${var.cluster_name}-controller-${count.index}"
    ROLE = var.role_tag_value
  }

  volume_tags = {
    Name = "${var.cluster_name}-volume"
    ROLE = var.role_tag_value
  }

  user_data = data.template_cloudinit_config.controller.rendered

  system_disk_category          = local.root_volume_type
  system_disk_size              = local.root_volume_size

  # gravity/docker data device
  data_disks {
    category              = local.gravity_volume_type
    name                  = local.gravity_volume_device_name
    size                  = local.gravity_volume_size
    delete_with_instance  = local.volume_delete_on_termination
  }

  # etcd device
  data_disks {
    category              = local.etcd_volume_type
    name                  = local.etcd_device_name
    size                  = local.etcd_volume_size
    delete_with_instance = local.volume_delete_on_termination
  }

}


resource "alicloud_instance" "worker_node" {
  image_id                      = data.alicloud_images.nodes.images[0].id
  instance_type                 = var.instance_type_worker
  internet_max_bandwidth_out    = var.enable_public_ips ? var.node_max_bandwidth : 0
  security_groups               = [alicloud_security_group.cluster.id]
  instance_name                 = "${var.cluster_name}-worker-${count.index}"

  vswitch_id                    = element(
    concat(var.existing_subnet_ids, alicloud_vswitch.public[*].id),
    count.index,
  )

  key_name = var.key_pair
  count    = var.workers

  tags = {
    Name = "${var.cluster_name}-worker-${count.index}"
    ROLE = var.role_tag_value
  }

  volume_tags = {
    Name = "${var.cluster_name}-volume"
    ROLE = var.role_tag_value
  }

  user_data = data.template_cloudinit_config.worker.rendered

  system_disk_category  = local.root_volume_type
  system_disk_size      = local.root_volume_size
  
  # gravity/docker data device
  data_disks  {
    category              = local.gravity_volume_type
    name                  = local.gravity_volume_device_name
    size                  = local.gravity_volume_size
    delete_with_instance  = local.volume_delete_on_termination
  }
}


