output "proxy_private_ip" {
  value = alicloud_instance.proxy[0].private_ip
}

output "proxy_public_ip" {
  value = alicloud_instance.proxy[0].public_ip
}
