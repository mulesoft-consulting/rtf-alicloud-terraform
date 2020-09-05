resource "alicloud_cen_instance_attachment" "cen_a" {
  instance_id              = var.cen_id
  child_instance_id        = alicloud_vpc.vpc[0].id
  child_instance_region_id = var.region
}
