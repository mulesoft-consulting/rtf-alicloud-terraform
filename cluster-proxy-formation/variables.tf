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

variable "role_tag_value" {
  default = "RuntimeFabric-proxy-terraform"
}

variable "vpc_cidr" {
  default = "172.41.0.0/16"
}

variable "cluster_vpc_cidr" {
  default = "172.31.0.0/16"
}
