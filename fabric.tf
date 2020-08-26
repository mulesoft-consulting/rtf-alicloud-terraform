provider "alicloud" {}

variable "key_pair" {
  default = ""
}

variable "cluster_name" {
  default = "mrRobot-runtime-fabric"
}

variable "controllers" {
  default = 1
}

variable "workers" {
  default = 2
}

variable "installer_url" {
  default = ""
}

variable "ami_name" {
  default = "centos_7_8_x64_20G_alibase_20200717.vhd"
}

variable "ami_owner_id" {
  default = "system"
}

variable "instance_type_controller" {
  default = "ecs.g6e.large"
}

variable "instance_type_worker" {
  default = "ecs.r6e.large"
}

variable "cluster_token" {
  default = ""
}

variable "role_tag_value" {
  default = "RuntimeFabric-terraform"
}

variable "vpc_cidr" {
  default = "172.31.0.0/16"
}

variable "activation_data" {
  default = ""
}

variable "anypoint_org_id" {
  default = ""
}

variable "anypoint_region" {
  default = "us-east-1"
}

variable "anypoint_endpoint" {
  default = "https://anypoint.mulesoft.com"
}

variable "anypoint_token" {
  default = ""
}

variable "mule_license" {
  default = ""
}

variable "enable_public_ips" {
  default = true
}

variable "existing_vpc_id" {
  default = ""
}

variable "existing_subnet_ids" {
  type = list(string)
  default = []
}

variable "kubernetes_api_cidr_blocks" {
  type = list(string)
  default = []
}

variable "ops_center_cidr_blocks" {
  type = list(string)
  default = []
}

variable "pod_network_cidr_block" {
  default = "10.244.0.0/16"
}

variable "service_cidr_block" {
  default = "10.100.0.0/16"
}

variable "http_proxy" {
  default = ""
}

variable "no_proxy" {
  default = ""
}

variable "monitoring_proxy" {
  default = ""
}

variable "egress_cidr_blocks" {
  type = string
  default = "0.0.0.0/0"
}

variable "ntp_egress_cidr_blocks" {
  type = string
  default = "0.0.0.0/0"
}

variable "service_uid" {
  default = ""
}

variable "service_gid" {
  default = ""
}

variable "agent_url" {
  default = ""
}




data "alicloud_zones" "available" { }

# Alicloud AMIs (Images)
data "alicloud_images" "nodes" {
  owners      = var.ami_owner_id
  most_recent = true
  name_regex  = var.ami_name
}


locals {
  root_volume_type = "cloud_efficiency"
  root_volume_size = "90"

  gravity_volume_type                            = "cloud_efficiency"
  gravity_volume_size                            = "250"
  #gravity_volume_size_inbound_traffic_controller = "50"
  gravity_volume_device_name                     = "/dev/xvdb"

  etcd_volume_type = "cloud_ssd"
  #etcd_volume_iops = "3000"
  etcd_volume_size = "60"
  etcd_device_name = "/dev/xvdc"

  volume_delete_on_termination = true

  #lb_subnet_mappings = concat(var.existing_subnet_ids, alicloud_instance.installer_node[*].subnet_id, alicloud_instance.controller_node[*].subnet_id)
}

resource "random_string" "cluster_token" {
  length  = 16
  special = false
}

data "template_file" "installer_env" {
  template = file("${path.module}/resources/installer_env.sh")

  vars = {
    cluster_name     = var.cluster_name
    cluster_token    = var.cluster_token != "" ? var.cluster_token : random_string.cluster_token.result
    activation_data  = var.activation_data
    installer_url    = var.installer_url
    org_id           = var.anypoint_org_id
    region           = var.anypoint_region
    endpoint         = var.anypoint_endpoint
    auth_token       = var.anypoint_token
    mule_license     = var.mule_license
    http_proxy       = var.http_proxy
    no_proxy         = var.no_proxy
    monitoring_proxy = var.monitoring_proxy
    service_uid      = var.service_uid
    service_gid      = var.service_gid
    agent_url        = var.agent_url
    pod_network_cidr_block = var.pod_network_cidr_block
    service_cidr_block     = var.service_cidr_block
  }
}

data "template_file" "controller_env" {
  template = file("${path.module}/resources/controller_env.sh")

  vars = {
    installer_ip     = alicloud_instance.installer_node[0].private_ip
    cluster_name     = var.cluster_name
    cluster_token    = var.cluster_token != "" ? var.cluster_token : random_string.cluster_token.result
    http_proxy       = var.http_proxy
    no_proxy         = var.no_proxy
    monitoring_proxy = var.monitoring_proxy
    service_uid      = var.service_uid
    service_gid      = var.service_gid
  }
}

data "template_file" "worker_env" {
  template = file("${path.module}/resources/worker_env.sh")

  vars = {
    installer_ip  = alicloud_instance.installer_node[0].private_ip
    cluster_name  = var.cluster_name
    cluster_token = var.cluster_token != "" ? var.cluster_token : random_string.cluster_token.result
    http_proxy    = var.http_proxy
    no_proxy      = var.no_proxy
    service_uid   = var.service_uid
    service_gid   = var.service_gid
  }
}


data "template_cloudinit_config" "installer" {
  part {
    filename     = "envvars.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.installer_env.rendered
  }

  part {
    filename     = "init.sh"
    content_type = "text/x-shellscript"
    content      = file("${path.module}/resources/init.sh")
  }
}

data "template_cloudinit_config" "controller" {
  part {
    filename     = "envvars.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.controller_env.rendered
  }

  part {
    filename     = "init.sh"
    content_type = "text/x-shellscript"
    content      = file("${path.module}/resources/init.sh")
  }
}

data "template_cloudinit_config" "worker" {
  part {
    filename     = "envvars.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.worker_env.rendered
  }

  part {
    filename     = "init.sh"
    content_type = "text/x-shellscript"
    content      = file("${path.module}/resources/init.sh")
  }
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

  count             = var.existing_vpc_id != "" ? 0 : length(data.alicloud_zones.available.zones[*].local_name)
  availability_zone = element(data.alicloud_zones.available.zones[*].local_name, count.index)

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

resource "alicloud_instance" "installer_node" {
  image_id                      = data.alicloud_images.nodes.id
  instance_type                 = var.instance_type_controller
  internet_max_bandwidth_out    = var.enable_public_ips ? 100 : 0
  vswitch_id                    = element(concat(var.existing_subnet_ids, alicloud_vswitch.public[*].id), 0)
  security_groups               = [alicloud_security_group.cluster.id]
  
  key_name  = var.key_pair
  count     = "1"

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
  image_id                      = data.alicloud_images.nodes.id
  instance_type                 = var.instance_type_controller
  internet_max_bandwidth_out    = var.enable_public_ips ? 100 : 0
  security_groups               = [alicloud_security_group.cluster.id]

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
  image_id                      = data.alicloud_images.nodes.id
  instance_type                 = var.instance_type_worker
  internet_max_bandwidth_out    = var.enable_public_ips ? 100 : 0
  security_groups               = [alicloud_security_group.cluster.id]

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
    delete_with_instance = local.volume_delete_on_termination
  }
}



output "controller_private_ips" {
  value = join(
    " ",
    alicloud_instance.installer_node[*].private_ip,
    alicloud_instance.controller_node[*].private_ip,
  )
}

output "worker_private_ips" {
  value = join(" ", alicloud_instance.worker_node[*].private_ip)
}

output "controller_public_ips" {
  value = join(
    " ",
    alicloud_instance.installer_node[*].public_ip,
    alicloud_instance.controller_node[*].public_ip,
  )
}

output "worker_public_ips" {
  value = join(" ", alicloud_instance.worker_node[*].public_ip)
}
