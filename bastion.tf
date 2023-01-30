########## CREATE INSTANCE - BASTION HOST ############

resource "google_compute_instance" "bastion-host" {
  name         = "bastion-host"
  machine_type = var.machine_type
  zone         = var.zone_a

  tags = ["bastion", "bancodedados"]

  labels      = {
    "project" = var.project,
    "name" = "bastion_host",
    "zone" = var.zone_a
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-lts"
    }
  }

  metadata_startup_script = "sudo apt update; sudo apt install -y apache2; sudo apt install mysql-client-core-8.0"
  network_interface {
    network = var.vpc_name
    subnetwork = var.subnet-public-1a
    access_config {
      // Ephemeral public IP
    }
  }

  service_account {
  # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    #email  = ""
    scopes = ["cloud-platform"]
  }

}
