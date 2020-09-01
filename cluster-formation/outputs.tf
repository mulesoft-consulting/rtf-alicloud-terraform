output "controller_private_ips" {
  value = join(
    " ",
    alicloud_instance.installer_node[*].private_ip,
    alicloud_instance.controller_node[*].private_ip,
  )
}

output "worker_private_ips" {
  value = join(" ", alicloud_instance.worker_node[*].private_ip)
}

output "controller_public_ips" {
  value = join(
    " ",
    alicloud_instance.installer_node[*].public_ip,
    alicloud_instance.controller_node[*].public_ip,
  )
}

output "worker_public_ips" {
  value = join(" ", alicloud_instance.worker_node[*].public_ip)
}
