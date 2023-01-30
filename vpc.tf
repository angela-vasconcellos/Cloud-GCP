terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.29.0"
    }
  }
  backend "gcs" {
   bucket  = "nome do bucket"
   prefix  = "terraform/state"
  }
}

provider "google" {
  credentials = file(var.chave)
  project = var.project
  region = var.region
  }

#################### CREATE VPC ############################

resource "google_compute_network" "vpc_network" {
  project                 = var.project
  name                    = var.vpc_name
  auto_create_subnetworks = false
  mtu                     = 1460
}


#################### CREATE PUBLIC SUBNETS ############################
resource "google_compute_subnetwork" "public-subnetwork-a" {
  name = "nome1"
  ip_cidr_range = var.subnet-public-1a
  region = var.region
  network = google_compute_network.vpc_network.name
  }

resource "google_compute_subnetwork" "public-subnetwork-c" {
  name = "nome2"
  ip_cidr_range = var.subnet-public-1c
  region = var.region
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
  network = google_compute_network.vpc_network.name
  }

#################### CREATE PRIVATE SUBNETS ############################

resource "google_compute_subnetwork" "private-subnetwork-app" {
  name = "nome3"
  ip_cidr_range = var.subnet-private-app-1a
  region = var.region
  network = google_compute_network.vpc_network.name
  }



