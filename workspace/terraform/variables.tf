terraform {
  required_version = ">= 1.7.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.36"
    }
  }
}

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region for VPC and subnet"
  type        = string
  default     = "europe-west1"
}

variable "zone" {
  description = "GCP zone for the GKE cluster"
  type        = string
  default     = "europe-west1-b"
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "gke-cluster-demo"
}

output "project_id" {
  value       = var.project_id
  description = "Terraform projesinde kullanılan GCP proje ID"
}
