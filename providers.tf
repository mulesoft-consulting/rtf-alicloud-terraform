provider "alicloud" {
  alias  = "cluster"
  region = var.cluster_region
}

provider "alicloud" {
  alias  = "cluster_proxy"
  region = var.cluster_proxy_region
}

