### Authentication
variable "oci_tenancy_id" {}
variable "oci_compartment_id" {}
variable "oci_user_id" {}
variable "oci_fingerprint" {}
variable "oci_private_key_path" {}
variable "oci_region" {
    default = "us-ashburn-1"
}

### General

# The name of the OKE cluster.
variable "cluster_name" {
  default = "test_cluster"
}

# Number of Availability Domains to use.
variable "availability_domain" {
  default = 3
}

# Whether to enable Kubernetes Dashboard.
variable "cluster_options_add_ons_is_kubernetes_dashboard_enabled" {
  default = true
}

# Whether to enable Tiller for Helm support.
variable "cluster_options_add_ons_is_tiller_enabled" {
  default = true
}

### Networking configuration.
variable "cluster_options_kubernetes_network_config_pods_cidr" {
  default = "10.1.0.0/16"
}

variable "cluster_options_kubernetes_network_config_services_cidr" {
  default = "10.2.0.0/16"
}

### Node Pool configuration.
variable "node_pool_initial_node_labels_key" {
  default = "key"
}

variable "node_pool_initial_node_labels_value" {
  default = "value"
}

variable "node_pool_name" {
  default = "node_pool"
}

variable "node_pool_node_image_name" {
  default = "Oracle-Linux-7.5"
}

variable "node_pool_node_shape" {
  default = "VM.Standard1.4"
}

variable "node_pool_quantity_per_subnet" {
  default = 2
}

variable "node_pool_ssh_public_key_path" {}