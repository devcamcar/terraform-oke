data "oci_identity_availability_domains" "oke_availability_domains" {
  compartment_id = "${var.oci_compartment_id}"
}

data "oci_containerengine_cluster_option" "oke_cluster_option" {
  cluster_option_id = "all"
}

data "oci_containerengine_node_pool_option" "oke_node_pool_option" {
  node_pool_option_id = "all"
}

output "cluster_kubernetes_versions" {
  value = ["${data.oci_containerengine_cluster_option.oke_cluster_option.kubernetes_versions}"]
}

output "node_pool_kubernetes_version" {
  value = ["${data.oci_containerengine_node_pool_option.oke_node_pool_option.kubernetes_versions}"]
}