data "alicloud_zones" "available" { }

# Alicloud AMIs (Images)
data "alicloud_images" "nodes" {
  owners      = var.ami_owner_id
  most_recent = true
  name_regex  = var.ami_name
}

data "template_file" "init_script" {
  template = file("${path.module}/resources/init.sh")

  vars = {
    nginx_conf = file("${path.module}/resources/nginx.conf")
  }
}

data "template_cloudinit_config" "proxy" {
  gzip          = false
  base64_encode = true

  part {
    filename     = "init.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.init_script.rendered
  }
  
}
