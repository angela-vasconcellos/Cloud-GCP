#################### CREATE FIREWALL RULES ############################

#ACESSO SSH - PARA BASTION
resource "google_compute_firewall" "rule-bastion" {
  project     = var.project
  name        = "firewall-bastion-22"
  network     = var.vpc_name

  allow {
    protocol  = "tcp"
    ports     = ["22"]
  }
  target_tags = ["bastion"]
  source_ranges = ["0.0.0.0/0"]
}

#ACESSO INTERNO - TODA A VPC
resource "google_compute_firewall" "rule-allow-custom" {
  project     = var.project
  name        = "rule-allow-custom"
  network     = var.vpc_name
  direction   = "INGRESS"
  priority    = "65534"

  allow {
    protocol = "all"
  }
  source_ranges = ["10.0.0.0/24", "10.0.1.0/24","10.0.4.0/24","10.0.5.0/24"]
}

#PERMITE O INTERNO - PARA DB
resource "google_compute_firewall" "local-allow" {
  project     = var.project
  name        = "local-allow"
  network     = var.vpc_name
  direction   = "EGRESS"
  destination_ranges = ["10.0.0.0/24"]
  priority    = "500"

  allow {
    protocol  = "all"
  }
  target_tags = ["protegido"]
}

#BLOQUEIA A INTERNET - PARA DB
resource "google_compute_firewall" "local-block" {
  project     = var.project
  name        = "local-block"
  network     = var.vpc_name
  direction   = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  priority    = "600"

  deny {
    protocol  = "all"
  }
  target_tags = ["protegido"]
}

#HTTP - para acessar via browser
resource "google_compute_firewall" "rule-http" {
  project     = var.project
  name        = "rule-http"
  network     = var.vpc_name

  allow {
    protocol  = "tcp"
    ports     = ["80"]
  }
  
  allow {
    protocol  = "tcp"
    ports     = ["5000"]
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

  target_tags = ["http"]
  source_ranges = ["0.0.0.0/0"]
}
