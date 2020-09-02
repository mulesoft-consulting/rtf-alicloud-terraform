variable "key_pair" {
  default = ""
}

variable "public_key" {
  default = ""
}

variable "name" {
  default = "mrRobot-runtime-fabric-proxy"
}

variable "ami_name" {
  default = "^centos_7_8"
}

variable "ami_owner_id" {
  default = "system"
}

variable "instance_type" {
  default = "ecs.g6e.large"
}

variable "node_max_bandwidth" {
  default = 100
}

variable "existing_vpc_id" {
  default = ""
}

variable "existing_subnet_ids" {
  type = list(string)
  default = []
}

variable "role_tag_value" {
  default = "RuntimeFabric-proxy-terraform"
}

variable "vpc_cidr" {
  default = "172.41.0.0/16"
}

variable "cluster_vpc_cidr" {
  default = "172.31.0.0/16"
}

variable "enable_public_ips" {
  default = true
}

variable "cen_id" {
  default = ""
}

variable "region" {
  default = ""
}

variable "http_proxy_port" {
  default = 443
}
