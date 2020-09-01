variable "key_pair" {
  default = ""
}

variable "public_key" {
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

variable "installer_scripts_url" {
  default= "https://anypoint.mulesoft.com/runtimefabric/api/download/scripts/latest"
}

variable "ami_name" {
  default = "^centos_7_8"
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

variable "node_max_bandwidth" {
  default = 100
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
  type = string
  default = ""
}

variable "ops_center_cidr_blocks" {
  type = string
  default = ""
}

variable "pod_network_cidr_block" {
  default = "10.244.0.0/16"
}

variable "service_cidr_block" {
  default = "10.100.0.0/16"
}

variable "proxy_private_ip" {
  default = ""
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

variable "cen_id" {
  default = ""
}

variable "region" {
  default = ""
}

variable "zone_ids" {
  type    = map(string)
  default = {}
}
