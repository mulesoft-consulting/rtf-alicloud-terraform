# VPC
resource "alicloud_vpc" "vpc" {
  name           = "${var.name}-vpc"
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

  count             = var.existing_vpc_id != "" ? 0 : length(data.alicloud_zones.available.zones[*].id)
  availability_zone = element(data.alicloud_zones.available.zones[*].id, count.index)

  tags = {
    Name = "${var.name}-subnet"
  }
}

# ROUTE TABLE FOR THE VPC
resource "alicloud_route_table" "rt" {
  vpc_id      = alicloud_vpc.vpc[0].id
  count       = var.existing_vpc_id != "" ? 0 : 1
  name        = "${var.name}-rt"
}

# RT Association to Subnet
resource "alicloud_route_table_attachment" "rta" {
  count          = length(alicloud_vswitch.public)
  vswitch_id     = element(alicloud_vswitch.public[*].id, count.index)
  route_table_id = alicloud_route_table.rt[0].id
}

resource "alicloud_key_pair" "key"{
  key_name   = var.key_pair
  public_key = var.public_key
}

locals {
  root_volume_type = "cloud_essd"
  root_volume_size = "90"
}

resource "alicloud_instance" "proxy" {
  image_id                      = var.image_id
  instance_type                 = var.instance_type
  internet_max_bandwidth_out    = var.enable_public_ips ? var.node_max_bandwidth : 0
  vswitch_id                    = element(concat(var.existing_subnet_ids, alicloud_vswitch.public[*].id), 0)
  security_groups               = [alicloud_security_group.proxy.id]
  instance_name                 = "${var.name}-proxy"
  host_name                     = "${var.name}-proxy"
  
  key_name  = var.key_pair
  count     = 1

  tags = {
    Name = "${var.name}-proxy"
    ROLE = var.role_tag_value
  }

  volume_tags = {
    Name = "${var.name}-volume"
    ROLE = var.role_tag_value
  }

  user_data = data.template_cloudinit_config.proxy.rendered

  system_disk_category  = local.root_volume_type
  system_disk_size      = local.root_volume_size
}
