output "proxy_private_ip" {
  value = length(module.rtf_cluster_proxy) > 0 ? module.rtf_cluster_proxy[0].proxy_private_ip : ""
}

output "proxy_public_ip" {
  value = length(module.rtf_cluster_proxy) > 0 ? module.rtf_cluster_proxy[0].proxy_public_ip : ""
}


output "controller_private_ips" {
  value = module.rtf_cluster.controller_private_ips
}

output "worker_private_ips" {
  value = module.rtf_cluster.controller_private_ips
}

output "controller_public_ips" {
  value = module.rtf_cluster.controller_private_ips
}

output "worker_public_ips" {
  value = module.rtf_cluster.controller_private_ips
}
