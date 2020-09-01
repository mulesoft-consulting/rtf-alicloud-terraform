module "rtf_cluster" {
  #source = "./cluster-formation"
  name = "rtf-cluster"
  providers  {
    alicloud = "alicloud.cluster"
  }
}

module "rtf_cluster_proxy" {
  #source = "./cluster-proxy-formation"
  name = "rtf-cluster-proxy"
  providers  {
    alicloud = "alicloud.cluster_proxy"
  }
}

output rtf-cluster {
  value       = module.rtf_cluster.providers
}

output rtf-cluster {
  value       = module.rtf_cluster_proxy.providers
}
