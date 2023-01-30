
# # #################### CREATE CLOUD ROUTER - NAT GATEWAY ############################

resource "google_compute_router" "router" {
    name    = "router"
    network = var.vpc_name
    region  = var.region
}

##################### CREATE NAT GATEWAY ############################

resource "google_compute_router_nat" "nat" {
  name                               = "router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
