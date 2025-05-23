output "network_name" {
  description = "VPC network adı"
  value       = google_compute_network.vpc.name
}

output "subnet_name" {
  description = "Subnetwork adı"
  value       = google_compute_subnetwork.subnet.name
}

output "cluster_name" {
  description = "GKE cluster adı"
  value       = google_container_cluster.gke_cluster.name
}

output "main_node_pool" {
  description = "main-pool adı"
  value       = google_container_node_pool.main_pool.name
}

output "app_node_pool" {
  description = "application-pool adı"
  value       = google_container_node_pool.application_pool.name
}
