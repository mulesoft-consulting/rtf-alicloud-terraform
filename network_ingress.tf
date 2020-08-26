resource "alicloud_security_group" "cluster" {
  name   = var.cluster_name
  vpc_id = var.existing_vpc_id != "" ? var.existing_vpc_id : join("", alicloud_vpc.vpc.*.id)

  tags = {
    Name = "${var.cluster_name}-cluster"
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
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = "0.0.0.0/0"
  description       = "SSH access"
}

/*
resource "alicloud_security_group_rule" "installer_61008" {
  type              = "ingress"
  port_range        = "61008/61010"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = var.vpc_cidr
  description       = "Installer agent ports"
}


resource "alicloud_security_group_rule" "installer_61022" {
  type              = "ingress"
  port_range        = "61022/61024"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = var.vpc_cidr
  description       = "Installer agent ports"
}


resource "alicloud_security_group_rule" "bandwidth" {
  type              = "ingress"
  port_range        = "4242/4242"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = var.vpc_cidr
  description       = "Bandwidth checker utility"
}


resource "alicloud_security_group_rule" "dns_udp" {
  type              = "ingress"
  port_range        = "53/53"
  ip_protocol       = "udp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = var.vpc_cidr
  description       = "Internal cluster DNS"
}


resource "alicloud_security_group_rule" "dns_tcp" {
  type              = "ingress"
  port_range        = "53/53"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = var.vpc_cidr
  description       = "Internal cluster DNS"
}


resource "alicloud_security_group_rule" "overlay" {
  type              = "ingress"
  port_range        = "8472/8472"
  ip_protocol       = "udp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = var.vpc_cidr
  description       = "Overlay network"
}

resource "alicloud_security_group_rule" "serf_7496" {
  type              = "ingress"
  port_range        = "7496/7496"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = var.vpc_cidr
  description       = "Serf (Health check agents) peer to peer"
}


resource "alicloud_security_group_rule" "serf_7496_udp" {
  type              = "ingress"
  port_range        = "7496/7496"
  ip_protocol       = "udp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = var.vpc_cidr
  description       = "Serf (Health check agents) peer to peer"
}


resource "alicloud_security_group_rule" "serf_7373" {
  type              = "ingress"
  port_range        = "7373/7373"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = var.vpc_cidr
  description       = "Serf (Health check agents) peer to peer"
}

resource "alicloud_security_group_rule" "cluster_status" {
  type              = "ingress"
  port_range        = "7575/7575"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = var.vpc_cidr
  description       = "Cluster status gRPC API"
}

resource "alicloud_security_group_rule" "etcd_2379" {
  type              = "ingress"
  port_range        = "2379/2380"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = var.vpc_cidr
  description       = "Etcd server communications"
}

resource "alicloud_security_group_rule" "etcd_4001" {
  type              = "ingress"
  port_range        = "4001/4001"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = var.vpc_cidr
  description       = "Etcd server communications"
}

resource "alicloud_security_group_rule" "etcd_7001" {
  type              = "ingress"
  port_range        = "7001/7001"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = var.vpc_cidr
  description       = "Etcd server communications"
}

resource "alicloud_security_group_rule" "kubernetes_api" {
  type              = "ingress"
  port_range        = "6443/6443"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = var.vpc_cidr
  description       = "Kubernetes API server"
}

resource "alicloud_security_group_rule" "kubernetes_api_external" {
  type              = "ingress"
  port_range        = "6443/6443"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  count             = length(var.kubernetes_api_cidr_blocks) == 0 ? 0 : 1
  cidr_ip           = var.kubernetes_api_cidr_blocks
  description       = "Kubernetes API server (ext)"
}

resource "alicloud_security_group_rule" "k8s_components" {
  type              = "ingress"
  port_range        = "10248/10250"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = var.vpc_cidr
  description       = "Kubernetes components"
}

resource "alicloud_security_group_rule" "k8s_components_2" {
  type              = "ingress"
  port_range        = "10255/10255"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = var.vpc_cidr
  description       = "Kubernetes components"
}

resource "alicloud_security_group_rule" "docker_registry" {
  type              = "ingress"
  port_range        = "5000/5000"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = var.vpc_cidr
  description       = "Internal Docker registry"
}

resource "alicloud_security_group_rule" "internal_teleport" {
  type              = "ingress"
  port_range        = "3022/3025"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = var.vpc_cidr
  description       = "Teleport internal SSH control panel"
}

resource "alicloud_security_group_rule" "internal_telekube" {
  type              = "ingress"
  port_range        = "3008/3012"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = var.vpc_cidr
  description       = "Internal Telekube services"
}

resource "alicloud_security_group_rule" "ops_center" {
  type              = "ingress"
  port_range        = "32009/32009"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = var.vpc_cidr
  description       = "OpsCenter UI"
}

resource "alicloud_security_group_rule" "ops_center_external" {
  type              = "ingress"
  port_range        = "32009/32009"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  count             = length(var.ops_center_cidr_blocks) == 0 ? 0 : 1
  cidr_ip           = var.ops_center_cidr_blocks
  description       = "OpsCenter UI"
}

resource "alicloud_security_group_rule" "rtf_agent" {
  type              = "ingress"
  port_range        = "30945/30945"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = var.vpc_cidr
  description       = "RTF Agent API"
}
*/

resource "alicloud_security_group_rule" "ingress_https" {
  type              = "ingress"
  port_range        = "443/443"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.cluster.id
  cidr_ip           = "0.0.0.0/0"
  description       = "HTTPS ingress"
}


