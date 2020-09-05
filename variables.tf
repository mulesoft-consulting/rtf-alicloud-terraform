variable "access_key_id" {
  default = ""
}

variable "access_key_secret" {
  default = ""
}

variable cluster_region {
  type        = string
  default     = ""
  description = "the cluster's region"
}

variable cluster_proxy_region {
  type        = string
  default     = ""
  description = "the cluster proxy's region"
}

variable "key_pair" {
  default = ""
}

variable "public_key" {
  default = ""
}

variable "controllers" {
  default = 1
}

variable "workers" {
  default = 2
}

variable "installer_scripts_url" {
  default= "https://anypoint.mulesoft.com/runtimefabric/api/download/scripts/latest"
}

variable "cluster_vpc_cidr" {
  default = "172.31.0.0/16"
}

variable "cluster_proxy_vpc_cidr" {
  default = "192.168.0.0/16"
}

variable "activation_data" {
  default = ""
}

variable "anypoint_region" {
  default = "us-east-1"
}

variable "anypoint_endpoint" {
  default = "https://anypoint.mulesoft.com"
}

variable "mule_license" {
  default = ""
}

variable "enable_public_ips" {
  default = true
}

variable "http_proxy" {
  default = ""
}

variable "no_proxy" {
  default = ""
}

variable "cen_id" {
  default = ""
}

