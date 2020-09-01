# amazonaws.com Zone 
/* resource "alicloud_pvtz_zone" "amazonaws_pz" {
  name  = "amazonaws.com"
  count = var.proxy_private_ip == "" ? 0 : 1
}
resource "alicloud_pvtz_zone_record" "amazonaws" {
  count           = var.proxy_private_ip == "" ? 0 : 1
  zone_id         = alicloud_pvtz_zone.amazonaws_pz[0].id
  resource_record = "*"
  type            = "A"
  value           = var.proxy_private_ip
  ttl             = 60
} */
resource "alicloud_pvtz_zone_attachment" "amazonaws_pza" {
  count   = var.proxy_private_ip == "" ? 0 : 1
  zone_id = "6bbdb7099f643efa9de36a84c6e88d3e" //alicloud_pvtz_zone.amazonaws_pz[0].id
  vpc_ids = [alicloud_vpc.vpc[0].id]
}


#----------------------------------------------------------------------

# PRIVATE ZONE
/* resource "alicloud_pvtz_zone" "googleapis_pz" {
  name  = "googleapis.com"
  count = var.proxy_private_ip == "" ? 0 : 1
}
resource "alicloud_pvtz_zone_record" "googleapis" {
  count           = var.proxy_private_ip == "" ? 0 : 1
  zone_id         = alicloud_pvtz_zone.googleapis_pz[0].id
  resource_record = "*"
  type            = "A"
  value           = var.proxy_private_ip
  ttl             = 60
} */
resource "alicloud_pvtz_zone_attachment" "googleapis_pza" {
  count   = var.proxy_private_ip == "" ? 0 : 1
  zone_id = "303be43aa603cb141c3f707b6df4442d" //alicloud_pvtz_zone.googleapis_pz[0].id
  vpc_ids = [alicloud_vpc.vpc[0].id]
}


#----------------------------------------------------------------------

# PRIVATE ZONE
/* resource "alicloud_pvtz_zone" "msap_pz" {
  count = var.proxy_private_ip == "" ? 0 : 1
  name  = "msap.io"
}
resource "alicloud_pvtz_zone_record" "msap" {
  count           = var.proxy_private_ip == "" ? 0 : 1
  zone_id         = alicloud_pvtz_zone.msap_pz[0].id
  resource_record = "*"
  type            = "A"
  value           = var.proxy_private_ip
  ttl             = 60
} */
resource "alicloud_pvtz_zone_attachment" "msap_pza" {
  count   = var.proxy_private_ip == "" ? 0 : 1
  zone_id = "8b3e6175f6f36a36cb55d0161e512527" //alicloud_pvtz_zone.msap_pz[0].id
  vpc_ids = [alicloud_vpc.vpc[0].id]
}


#----------------------------------------------------------------------

# PRIVATE ZONE
/* resource "alicloud_pvtz_zone" "cloudhub_pz" {
  count = var.proxy_private_ip == "" ? 0 : 1
  name  = "cloudhub.io"
}
resource "alicloud_pvtz_zone_record" "cloudhub" {
  count           = var.proxy_private_ip == "" ? 0 : 1
  zone_id         = alicloud_pvtz_zone.cloudhub_pz[0].id
  resource_record = "*"
  type            = "A"
  value           = var.proxy_private_ip
  ttl             = 60
} */
resource "alicloud_pvtz_zone_attachment" "cloudhub_pza" {
  count   = var.proxy_private_ip == "" ? 0 : 1
  zone_id = "6189226e22a4a974e27121535abc87b3" //alicloud_pvtz_zone.cloudhub_pz[0].id
  vpc_ids = [alicloud_vpc.vpc[0].id]
}


#----------------------------------------------------------------------

# PRIVATE ZONE
/* resource "alicloud_pvtz_zone" "mulesoft_pz" {
  count = var.proxy_private_ip == "" ? 0 : 1
  name  = "mulesoft.com"
}
resource "alicloud_pvtz_zone_record" "mulesoft" {
  count           = var.proxy_private_ip == "" ? 0 : 1
  zone_id         = alicloud_pvtz_zone.mulesoft_pz[0].id
  resource_record = "*"
  type            = "A"
  value           = var.proxy_private_ip
  ttl             = 60
} */
resource "alicloud_pvtz_zone_attachment" "mulesoft_pza" {
  count   = var.proxy_private_ip == "" ? 0 : 1
  zone_id = "eab722f7ac27b0cefe26caa696112cc5" //alicloud_pvtz_zone.mulesoft_pz[0].id
  vpc_ids = [alicloud_vpc.vpc[0].id]
}


#----------------------------------------------------------------------
