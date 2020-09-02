data "alicloud_zones" "available" { }

/* data "alicloud_instance_types" "controller" {
  cpu_core_count = 2
  memory_size    = 8
  network_type   = "vpc"
}

data "alicloud_instance_types" "worker" {
  
} */

# Alicloud AMIs (Images)
data "alicloud_images" "nodes" {
  owners      = var.ami_owner_id
  most_recent = true
  name_regex  = var.ami_name
}

data "template_file" "init_script" {
  template = file("${path.module}/resources/pre-init.sh")

  vars = {
    installer_scripts_url = var.installer_scripts_url
    proxy_url             = var.http_proxy
  }
}

data "template_file" "installer_env" {
  template = file("${path.module}/resources/installer_env.sh")

  vars = {
    cluster_name     = var.cluster_name
    cluster_token    = var.cluster_token != "" ? var.cluster_token : random_string.cluster_token.result
    activation_data  = var.activation_data
    installer_url    = var.installer_url
    org_id           = var.anypoint_org_id
    region           = var.anypoint_region
    endpoint         = var.anypoint_endpoint
    auth_token       = var.anypoint_token
    mule_license     = var.mule_license
    http_proxy       = var.http_proxy
    no_proxy         = var.no_proxy
    monitoring_proxy = var.monitoring_proxy
    service_uid      = var.service_uid
    service_gid      = var.service_gid
    agent_url        = var.agent_url
    pod_network_cidr_block = var.pod_network_cidr_block
    service_cidr_block     = var.service_cidr_block
  }
}

data "template_file" "controller_env" {
  template = file("${path.module}/resources/controller_env.sh")

  vars = {
    installer_ip     = alicloud_instance.installer_node[0].private_ip
    cluster_name     = var.cluster_name
    cluster_token    = var.cluster_token != "" ? var.cluster_token : random_string.cluster_token.result
    http_proxy       = var.http_proxy
    no_proxy         = var.no_proxy
    monitoring_proxy = var.monitoring_proxy
    service_uid      = var.service_uid
    service_gid      = var.service_gid
  }
}

data "template_file" "worker_env" {
  template = file("${path.module}/resources/worker_env.sh")

  vars = {
    installer_ip  = alicloud_instance.installer_node[0].private_ip
    cluster_name  = var.cluster_name
    cluster_token = var.cluster_token != "" ? var.cluster_token : random_string.cluster_token.result
    http_proxy    = var.http_proxy
    no_proxy      = var.no_proxy
    service_uid   = var.service_uid
    service_gid   = var.service_gid
  }
}



data "template_cloudinit_config" "installer" {
  gzip          = false
  base64_encode = true

  part {
    filename     = "envvars.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.installer_env.rendered
  }
  
  part {
    filename     = "init.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.init_script.rendered
  }
  
}

data "template_cloudinit_config" "controller" {
  gzip          = false
  base64_encode = true

  part {
    filename     = "envvars.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.controller_env.rendered
  }

  part {
    filename     = "init.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.init_script.rendered
  }
  
}

data "template_cloudinit_config" "worker" {
  gzip          = false
  base64_encode = true

  part {
    filename     = "envvars.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.worker_env.rendered
  }
  
  part {
    filename     = "init.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.init_script.rendered
  }

}
