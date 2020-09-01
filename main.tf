module "rtf_cluster" {
  source                = "./cluster-formation"
  #Parameters
  key_pair              = var.key_pair
  public_key            = var.public_key
  controllers           = var.controllers
  workers               = var.workers
  installer_scripts_url = var.installer_scripts_url
  vpc_cidr              = var.cluster_vpc_cidr
  activation_data       = var.activation_data
  anypoint_region       = var.anypoint_region
  anypoint_endpoint     = var.anypoint_endpoint
  mule_license          = var.mule_license
  enable_public_ips     = var.enable_public_ips
  http_proxy            = var.http_proxy
  no_proxy              = var.no_proxy
  
  providers = {
    alicloud = alicloud.cluster
  }
}

module "rtf_cluster_proxy" {
  source = "./cluster-proxy-formation"
  #Parameters
  key_pair          = var.key_pair
  public_key        = var.public_key
  enable_public_ips = var.enable_public_ips
  vpc_cidr          = var.cluster_proxy_vpc_cidr
  cluster_vpc_cidr  = var.cluster_vpc_cidr

  providers = {
    alicloud = alicloud.cluster_proxy
  }
}
