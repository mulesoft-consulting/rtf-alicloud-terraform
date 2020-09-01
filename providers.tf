variable cluster_region {
  type        = string
  default     = ""
  description = "the cluster's region"
}

variable cluster_proxy_region {
  type        = string
  default     = "eu-central-1"
  description = "the cluster proxy's region"
}

provider "alicloud" {
  alias = "cluster"
  region = var.cluster_region
}

provider "alicloud" {
  alias = "cluster_proxy"
  region = var.cluster_proxy_region
}

