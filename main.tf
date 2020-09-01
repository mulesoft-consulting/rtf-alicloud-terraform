module "rtf_cluster" {
  source                = "./modules/cluster-formation"
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
  region                = var.cluster_region
  cen_id                = var.cen_id
  # If no proxy region is provided then the cluster will be created without proxy integration
  proxy_private_ip      = var.cluster_proxy_region == "" ? "" : module.rtf_cluster_proxy[0].proxy_private_ip
  
  providers = {
    alicloud = alicloud.cluster
  }
}

module "rtf_cluster_proxy" {
  #If no proxy region is provided, then no proxy will be created
  count             = var.cluster_proxy_region == "" ? 0 : 1
  source            = "./modules/cluster-proxy-formation"
  #Parameters
  key_pair          = var.key_pair
  public_key        = var.public_key
  enable_public_ips = var.enable_public_ips
  vpc_cidr          = var.cluster_proxy_vpc_cidr
  cluster_vpc_cidr  = var.cluster_vpc_cidr
  region            = var.cluster_proxy_region
  cen_id            = var.cen_id

  providers = {
    alicloud = alicloud.cluster_proxy
  }
}
