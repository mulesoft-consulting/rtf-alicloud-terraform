provider "alicloud" {
  alias  = "cluster"
  region = var.cluster_region
  access_key = var.access_key_id
  secret_key = var.access_key_secret
}

provider "alicloud" {
  alias  = "cluster_proxy"
  region = var.cluster_proxy_region
  access_key = var.access_key_id
  secret_key = var.access_key_secret
}

