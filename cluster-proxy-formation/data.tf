data "alicloud_zones" "available" { }

# Alicloud AMIs (Images)
data "alicloud_images" "nodes" {
  owners      = var.ami_owner_id
  most_recent = true
  name_regex  = var.ami_name
}


data "template_cloudinit_config" "proxy" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "init.sh"
    content_type = "text/x-shellscript"
    content      = file("${path.module}/resources/init.sh")
  }
  
}
