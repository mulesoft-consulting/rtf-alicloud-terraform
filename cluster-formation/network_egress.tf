
locals {
  monitoring_proxy_split1 = split("://", var.monitoring_proxy)
  monitoring_proxy_hoststring = element(
    local.monitoring_proxy_split1,
    length(local.monitoring_proxy_split1) - 1,
  )
  monitoring_proxy_split2 = split("@", local.monitoring_proxy_hoststring)
  monitoring_proxy_ipport = element(
    local.monitoring_proxy_split2,
    length(local.monitoring_proxy_split2) - 1,
  )
  monitoring_proxy_ip   = element(split(":", local.monitoring_proxy_ipport), 0)
  monitoring_proxy_port = element(split(":", local.monitoring_proxy_ipport), 1)

  http_proxy_split1     = split("://", var.http_proxy)
  http_proxy_hoststring = element(local.http_proxy_split1, length(local.http_proxy_split1) - 1)
  http_proxy_split2     = split("@", local.http_proxy_hoststring)
  http_proxy_ipport     = element(local.http_proxy_split2, length(local.http_proxy_split2) - 1)
  http_proxy_ip         = element(split(":", local.http_proxy_ipport), 0)
  http_proxy_port       = element(split(":", local.http_proxy_ipport), 1)
}


resource "alicloud_security_group_rule" "egress_traffic" {
  type              = "egress"
  port_range        = "0/0"
  ip_protocol       = "all"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = var.egress_cidr_blocks
  description       = "Outbound"
}

resource "alicloud_security_group_rule" "cluster_egress_traffic" {
  type              = "egress"
  port_range        = "0/0"
  ip_protocol       = "all"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = var.egress_cidr_blocks
  description       = "In-cluster Outbound"
}

resource "alicloud_security_group_rule" "http_proxy_egress_traffic" {
  type              = "egress"
  port_range        = "${local.http_proxy_port}/${local.http_proxy_port}"
  ip_protocol       = "tcp"
  nic_type          = "internet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = format("%s/32", local.http_proxy_ip)
  description       = "Http Proxy Outbound"

  # create this egress rule if http_proxy is not null, and http_proxy_ip is a ipv4
  count = var.http_proxy != "" && replace(local.http_proxy_ip, "/(\\d{1,3}\\.){3}\\d{1,3}/", "") == "" ? 1 : 0
}

resource "alicloud_security_group_rule" "monitoring_proxy_egress_traffic" {
  type              = "egress"
  port_range        = "${local.monitoring_proxy_port}/${local.monitoring_proxy_port}"
  ip_protocol       = "tcp"
  nic_type          = "internet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = format("%s/32", local.monitoring_proxy_ip)
  description       = "Monitoring Proxy Outbound"

  # create this egress rule if http_proxy is not null, and http_proxy_ip is a ipv4
  count = var.monitoring_proxy != "" && replace(local.monitoring_proxy_ip, "/(\\d{1,3}\\.){3}\\d{1,3}/", "") == "" ? 1 : 0
}

resource "alicloud_security_group_rule" "ntp_egress_traffic" {
  type              = "egress"
  port_range        = "123/123"
  ip_protocol       = "udp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = var.ntp_egress_cidr_blocks
  description       = "NTP Outbound"
}
