data "alicloud_zones" "available" { }

data "template_file" "init_script" {
  template = file("${path.module}/resources/init.sh")

  vars = {
    nginx_conf  = file("${path.module}/resources/nginx.conf")
    nginx_initd = file("${path.module}/resources/nginx_initd.sh")
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
