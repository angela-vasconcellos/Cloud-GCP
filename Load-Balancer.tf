# forwarding rule
resource "google_compute_forwarding_rule" "forwarding-rule-lb" {
  name                  = "forwarding-rule-lb"
  project               = var.project
  depends_on            = [google_compute_subnetwork.public-subnetwork-c]
  region                = var.region
  provider              = google
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"

  network_tier          = "STANDARD"
  network               = google_compute_network.vpc_network.id
  target                = google_compute_region_target_http_proxy.target-http-proxy-lb.id
  
}

# http proxy
resource "google_compute_region_target_http_proxy" "target-http-proxy-lb" {
  name     = "target-http-proxy-lb"
  provider = google
  #region   = "us-central1"
  url_map  = google_compute_region_url_map.url-map-lb.id
}

# url map
resource "google_compute_region_url_map" "url-map-lb" {
  name            = "url-map-lb"
  provider        = google
  region          = var.region
  default_service = google_compute_region_backend_service.backend-service-lb.id


 #URL MAP - PORTA 5000
  host_rule {
    hosts        = ["*"]
    path_matcher = "http-api-clientes"
  }

  path_matcher {
    name            = "http-api-clientes"
    default_service = google_compute_region_backend_service.backend-service-lb-api-clientes.self_link

    path_rule {
        paths   = ["/clientes","/health","/clientes/*"]
        service = google_compute_region_backend_service.backend-service-lb-api-clientes.self_link
    }
  }

 #URL MAP - PORTA 5001
  host_rule {
    hosts        = ["*"]
    path_matcher = "http-api-enderecos"
  }

  path_matcher {
    name            = "http-api-enderecos"
    default_service = google_compute_region_backend_service.backend-service-lb-api-enderecos.self_link

    path_rule {
        paths   = ["/enderecos","/health2","/enderecos/*"]
        service = google_compute_region_backend_service.backend-service-lb-api-enderecos.self_link
    }

  }


 #URL MAP - PORTA 5002
  host_rule {
    hosts        = ["*"]
    path_matcher = "http-api-catalogo"
  }

  path_matcher {
    name            = "http-api-catalogo"
    default_service = google_compute_region_backend_service.backend-service-lb-api-catalogo.self_link

    path_rule {
        paths   = ["/produtos","/health3","/produto/*"]
        service = google_compute_region_backend_service.backend-service-lb-api-catalogo.self_link
    }
  }

 #URL MAP - PORTA 5003
  host_rule {
    hosts        = ["*"]
    path_matcher = "http-api-inventario"
  }

  path_matcher {
    name            = "http-api-inventario"
    default_service = google_compute_region_backend_service.backend-service-lb-api-inventario.self_link

    path_rule {
        paths   = ["/historico","/health4"]
        service = google_compute_region_backend_service.backend-service-lb-api-inventario.self_link
    }

  }

}



# backend service PORTA 80
resource "google_compute_region_backend_service" "backend-service-lb" {
  name                     = "backend-service-lb"
  region                   = var.region
  provider                 = google
  protocol                 = "HTTP"
  port_name                = "http-web"
  load_balancing_scheme    = "EXTERNAL_MANAGED"
  timeout_sec              = 10
  health_checks            = [google_compute_region_health_check.hc-lb.id]


  backend {
  group = google_compute_region_instance_group_manager.instance-group.instance_group
  balancing_mode = "UTILIZATION"
  capacity_scaler = 1.0
  }

}

# health check PORTA 80
resource "google_compute_region_health_check" "hc-lb" {
  name     = "hc-lb"
  provider = google
  
  timeout_sec         = 5
  check_interval_sec  = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10

  http_health_check {
    port = "80"
  }

}



# backend service PORTA 5000
resource "google_compute_region_backend_service" "backend-service-lb-api-clientes" {
  name                     = "backend-service-lb-api-clientes"
  region                   = var.region
  provider                 = google
  protocol                 = "HTTP"
  port_name                = "http-api-clientes"
  load_balancing_scheme    = "EXTERNAL_MANAGED"
  timeout_sec              = 10
  health_checks            = [google_compute_region_health_check.hc-lb-api-clientes.id]

  backend {
  group = google_compute_region_instance_group_manager.instance-group.instance_group
  balancing_mode = "UTILIZATION"
  capacity_scaler = 1.0
  }

}

# health check PORTA 5000
resource "google_compute_region_health_check" "hc-lb-api-clientes" {
  name     = "hc-lb-api-clientes"
  provider = google
  
  timeout_sec         = 5
  check_interval_sec  = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10

  tcp_health_check {
    port = "5000"
  }

}

# backend service PORTA 5001
resource "google_compute_region_backend_service" "backend-service-lb-api-enderecos" {
  name                     = "backend-service-lb-api-enderecos"
  region                   = var.region
  provider                 = google
  protocol                 = "HTTP"
  port_name                = "http-api-enderecos"
  load_balancing_scheme    = "EXTERNAL_MANAGED"
  timeout_sec              = 10
  health_checks            = [google_compute_region_health_check.hc-lb-api-enderecos.id]

  backend {
  group = google_compute_region_instance_group_manager.instance-group.instance_group
  balancing_mode = "UTILIZATION"
  capacity_scaler = 1.0
  }

}

# health check PORTA 5001
resource "google_compute_region_health_check" "hc-lb-api-enderecos" {
  name     = "hc-lb-api-enderecos"
  provider = google
  
  timeout_sec         = 5
  check_interval_sec  = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10

  tcp_health_check {
    port = "5001"
  }

}

# backend service PORTA 5002
resource "google_compute_region_backend_service" "backend-service-lb-api-catalogo" {
  name                     = "backend-service-lb-api-catalogo"
  region                   = var.region
  provider                 = google
  protocol                 = "HTTP"
  port_name                = "http-api-catalogo"
  load_balancing_scheme    = "EXTERNAL_MANAGED"
  timeout_sec              = 10
  health_checks            = [google_compute_region_health_check.hc-lb-api-catalogo.id]

  backend {
  group = google_compute_region_instance_group_manager.instance-group.instance_group
  balancing_mode = "UTILIZATION"
  capacity_scaler = 1.0
  }

}

# health check PORTA 5002
resource "google_compute_region_health_check" "hc-lb-api-catalogo" {
  name     = "hc-lb-api-catalogo"
  provider = google
  
  timeout_sec         = 5
  check_interval_sec  = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10

  tcp_health_check {
    port = "5002"
  }

}


# backend service PORTA 5003
resource "google_compute_region_backend_service" "backend-service-lb-api-inventario" {
  name                     = "backend-service-lb-api-inventario"
  region                   = var.region
  provider                 = google
  protocol                 = "HTTP"
  port_name                = "http-api-inventario"
  load_balancing_scheme    = "EXTERNAL_MANAGED"
  timeout_sec              = 10
  health_checks            = [google_compute_region_health_check.hc-lb-api-inventario.id]

  backend {
  group = google_compute_region_instance_group_manager.instance-group.instance_group
  balancing_mode = "UTILIZATION"
  capacity_scaler = 1.0
  }

}

# health check PORTA 5003
resource "google_compute_region_health_check" "hc-lb-api-inventario" {
  name     = "hc-lb-api-inventario"
  provider = google
  
  timeout_sec         = 5
  check_interval_sec  = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10

  tcp_health_check {
    port = "5003"
  }

}



# REGRAS DE FIREWALL - ALLOW HEALTH CHECK 
resource "google_compute_firewall" "fw-allow-hc-lb" {
  name          = "fw-allow-hc-lb"
  provider      = google
  direction     = "INGRESS"
  network       = google_compute_network.vpc_network.id
  source_ranges = ["10.0.1.0/24"]

  allow {
    protocol = "tcp"
    ports = ["80"]
  }

  allow {
    protocol = "tcp"
    ports = ["5000"]
  }

  allow {
    protocol  = "tcp"
    ports     = ["5001"]
  }

  allow {
    protocol  = "tcp"
    ports     = ["5002"]
  }

  allow {
    protocol  = "tcp"
    ports     = ["5003"]
  }

  target_tags = ["allow-health-check"]
}  
