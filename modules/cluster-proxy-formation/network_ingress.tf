resource "alicloud_security_group" "proxy" {
  name   = var.name
  vpc_id = var.existing_vpc_id != "" ? var.existing_vpc_id : join("", alicloud_vpc.vpc.*.id)

  tags = {
    Name = "${var.name}-proxy"
    ROLE = var.role_tag_value
  }
}


resource "alicloud_security_group_rule" "ssh" {
  type              = "ingress"
  port_range        = "22/22"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.proxy.id
  cidr_ip           = "0.0.0.0/0"
  description       = "SSH access"
}

resource "alicloud_security_group_rule" "ingress_5044_tcp" {
  type              = "ingress"
  port_range        = "5044/5044"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.proxy.id
  cidr_ip           = var.cluster_vpc_cidr
}

resource "alicloud_security_group_rule" "ingress_https" {
  type              = "ingress"
  port_range        = "${var.http_proxy_port}/${var.http_proxy_port}"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.proxy.id
  cidr_ip           = var.cluster_vpc_cidr
}

resource "alicloud_security_group_rule" "ingress_dns" {
  type              = "ingress"
  port_range        = "8888/8888"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.proxy.id
  cidr_ip           = var.cluster_vpc_cidr
}
