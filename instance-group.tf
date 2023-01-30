resource "google_compute_region_instance_group_manager" "instance-group" {
  name        = "instance-group"
  

  base_instance_name = "instance-group"
  region             = var.region
  distribution_policy_zones  = [var.zone_a, var.zone_c]

  auto_healing_policies {
    health_check      = google_compute_health_check.hc-instance.id
    initial_delay_sec = 300
  }

  named_port {
    name = "http-web"
    port = "80"
  }

  named_port {
    name = "http-api-clientes"
    port = "5000"
  }

  named_port {
    name = "http-api-enderecos"
    port = "5001"
  }

  named_port {
    name = "http-api-catalogo"
    port = "5002"
  }

  named_port {
    name = "http-api-inventario"
    port = "5003"
  }


  version {
    instance_template = google_compute_instance_template.instance-template.id

  }

}
resource "google_compute_health_check" "hc-instance" {
  name     = "hc-instance"
  provider = google
  
  timeout_sec         = 5
  check_interval_sec  = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10

  http_health_check {
    port = "80"
  }

}
