provider "alicloud" {
  alias  = "cluster"
  region = var.cluster_region
  access_key = var.accessKeyId
  secret_key = var.accessKeySecret
}

provider "alicloud" {
  alias  = "cluster_proxy"
  region = var.cluster_proxy_region
  access_key = var.accessKeyId
  secret_key = var.accessKeySecret
}

