resource "google_compute_instance_template" "instance-template" {
  name        = "instance-template"

  tags = ["instance-template", "allow-health-check", "http", "bancodedados"]

  labels      = {
    "project" = var.project,
    "name" = "instance_template_am"
  }

  machine_type         = "e2-micro"
  can_ip_forward       = false

  disk {
    source_image      = "ubuntu-2004-lts"
  }

  metadata_startup_script = "sudo apt update; sudo apt install -y pip; sudo apt install -y apache2; sudo apt install -y mysql-client-core-8.0"

  metadata = {
   ssh-keys = join("",[inserir nome do usuário e chave.json])
  }

  network_interface { 
    network = var.vpc_name
    subnetwork = var.subnet-private-app-1a
    stack_type = "IPV4_ONLY"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    #email  = 
    scopes = ["cloud-platform"]
  }
}
