
resource "google_compute_global_address" "private_ip_address" {
  provider = google-beta

  name          = "nome do banco de dados"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc_network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider = google-beta

  network                 = google_compute_network.vpc_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "db" {
  provider = google-beta

  name             = "db-${random_id.db_name_suffix.hex}"
  region           = var.region
  database_version = "MYSQL_8_0"

  depends_on = [google_service_networking_connection.private_vpc_connection]
  deletion_protection  = "false"
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = "inserir caminho da vpc"
      }

     user_labels = {
     "project" = var.project,
     "name" = "bastion_host",

      }
  }
}

resource "google_sql_database" "database" {
    name = "nome do banco de dados"
    instance = "${google_sql_database_instance.db.name}"
    charset = "utf8"
    collation = "utf8_general_ci"
   


}

resource "google_sql_user" "users" {
    name = " "
    instance = "${google_sql_database_instance.db.name}"
    host = " "
    password = " "
}

provider "google-beta" {
    credentials = file(var.chave)
    project = var.project
    region = var.region
}
