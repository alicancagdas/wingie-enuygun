provider "google" {
  project = var.project_id
  region  = var.region
}

# 1. Özel VPC (bölgesel)
resource "google_compute_network" "vpc" {
  name                    = "${var.cluster_name}-vpc"
  auto_create_subnetworks = false
}

# 2. Alt Ağ (bölgesel)
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.cluster_name}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.0.0.0/16"

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.1.0.0/16"
  }
  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.2.0.0/16"
  }
}

# 3. GKE Cluster (tek zonelik)
resource "google_container_cluster" "gke_cluster" {
  name                     = var.cluster_name
  location                 = var.zone
  remove_default_node_pool = true
  initial_node_count       = 1

  logging_service    = "none"
  monitoring_service = "none"

  network    = google_compute_network.vpc.id
  subnetwork = google_compute_subnetwork.subnet.id

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  network_policy {
    enabled = true
  }

  maintenance_policy {
    recurring_window {
      start_time = "2025-05-22T00:00:00Z"
      end_time   = "2025-05-22T23:59:59Z"
      recurrence = "FREQ=WEEKLY;BYDAY=SA,SU"
    }
  }
}

# 4. main-pool (tek node, autoscaling yok)
resource "google_container_node_pool" "main_pool" {
  name     = "main-pool"
  cluster  = google_container_cluster.gke_cluster.name
  location = var.zone

  initial_node_count = 1

  node_config {
    machine_type = "n2d-highcpu-2"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

# 5. application-pool (autoscaling açık)
resource "google_container_node_pool" "application_pool" {
  name     = "application-pool"
  cluster  = google_container_cluster.gke_cluster.name
  location = var.zone

  initial_node_count = 1

  node_config {
    machine_type = "n2d-highcpu-2"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }
}
