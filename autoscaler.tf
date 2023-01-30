resource "google_compute_region_autoscaler" "autoscaler" {
  name   = "autoscaler"
  target = google_compute_region_instance_group_manager.instance-group.id
  region = var.region

  autoscaling_policy {
    max_replicas    = 3
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 0.9
    }
  }
}
