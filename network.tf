// VCN Configuration.
resource "oci_core_virtual_network" "cluster_vcn" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = "${var.oci_compartment_id}"
  display_name   = "cluster_vcn"
}

resource "oci_core_internet_gateway" "cluster_ig" {
  compartment_id = "${var.oci_compartment_id}"
  display_name   = "cluster_ig"
  vcn_id         = "${oci_core_virtual_network.cluster_vcn.id}"
}

resource "oci_core_route_table" "cluster_route_table" {
  compartment_id = "${var.oci_compartment_id}"
  vcn_id         = "${oci_core_virtual_network.cluster_vcn.id}"
  display_name   = "cluster_route_table"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = "${oci_core_internet_gateway.cluster_ig.id}"
  }
}

// Subnet Configuration.
resource "oci_core_subnet" "cluster_subnet_1" {
  #Required
  availability_domain = "${lookup(data.oci_identity_availability_domains.oke_availability_domains.availability_domains[var.availability_domain - 2],"name")}"
  cidr_block          = "10.0.20.0/24"
  compartment_id      = "${var.oci_compartment_id}"
  vcn_id              = "${oci_core_virtual_network.cluster_vcn.id}"

  # Provider code tries to maintain compatibility with old versions.
  security_list_ids = ["${oci_core_virtual_network.cluster_vcn.default_security_list_id}"]
  display_name      = "cluster_subnet_1"
  route_table_id    = "${oci_core_route_table.cluster_route_table.id}"
}

resource "oci_core_subnet" "cluster_subnet_2" {
  #Required
  availability_domain = "${lookup(data.oci_identity_availability_domains.oke_availability_domains.availability_domains[var.availability_domain -1],"name")}"
  cidr_block          = "10.0.21.0/24"
  compartment_id      = "${var.oci_compartment_id}"
  vcn_id              = "${oci_core_virtual_network.cluster_vcn.id}"
  display_name        = "cluster_subnet_2"

  # Provider code tries to maintain compatibility with old versions.
  security_list_ids = ["${oci_core_virtual_network.cluster_vcn.default_security_list_id}"]
  route_table_id    = "${oci_core_route_table.cluster_route_table.id}"
}

resource "oci_core_subnet" "nodepool_subnet_1" {
  #Required
  availability_domain = "${lookup(data.oci_identity_availability_domains.oke_availability_domains.availability_domains[var.availability_domain -2],"name")}"
  cidr_block          = "10.0.22.0/24"
  compartment_id      = "${var.oci_compartment_id}"
  vcn_id              = "${oci_core_virtual_network.cluster_vcn.id}"

  # Provider code tries to maintain compatibility with old versions.
  security_list_ids = ["${oci_core_virtual_network.cluster_vcn.default_security_list_id}"]
  display_name      = "nodepool_subnet_1"
  route_table_id    = "${oci_core_route_table.cluster_route_table.id}"
}

resource "oci_core_subnet" "nodepool_subnet_2" {
  #Required
  availability_domain = "${lookup(data.oci_identity_availability_domains.oke_availability_domains.availability_domains[var.availability_domain -1],"name")}"
  cidr_block          = "10.0.23.0/24"
  compartment_id      = "${var.oci_compartment_id}"
  vcn_id              = "${oci_core_virtual_network.cluster_vcn.id}"

  # Provider code tries to maintain compatibility with old versions.
  security_list_ids = ["${oci_core_virtual_network.cluster_vcn.default_security_list_id}"]
  display_name      = "nodepool_subnet_2"
  route_table_id    = "${oci_core_route_table.cluster_route_table.id}"
}

# Security Lists Configuration.
resource "oci_core_security_list" "cluster-sec-list" {
  compartment_id = "${var.oci_compartment_id}"
  display_name   = "cluster_sec_list"
  vcn_id         = "${oci_core_virtual_network.cluster_vcn.id}"
    egress_security_rules = [
  		{
      protocol    = "all"
      destination = "0.0.0.0/0"
      stateless   = "true"
      },
  	]
    ingress_security_rules = [
      {
        protocol  = "6"
        source    = "0.0.0.0/0"
        stateless = "true"
      },
    ]
}

resource "oci_core_security_list" "nodepool-sec-list" {
  compartment_id = "${var.oci_compartment_id}"
  display_name   = "nodepool_sec_list"
  vcn_id         = "${oci_core_virtual_network.cluster_vcn.id}"
    egress_security_rules = [
      {
        protocol    = "all"
        destination = "10.0.0.0/16"
        stateless   = "true"
      },
      {
        protocol    = "all"
        destination = "0.0.0.0/0"
        stateless   = "false"
      },
    ]
    ingress_security_rules = [
      {
        #rules 1-3
        protocol  = "all"
        source    = "10.0.0.0/16"
        stateless = "true"
      },
      {
        #rule 4
        protocol  = "1"
        source    = "0.0.0.0/0"
        stateless = "false"
      },
      {
        #rule 5
        protocol  = "6"
        source    = "130.35.0.0/16"
        stateless = "false"

        tcp_options {
          "max" = 22
          "min" = 22
        }
      },
      {
        #rule 6
        protocol  = "6"
        source    = "138.1.0.0/17"
        stateless = "false"

        tcp_options {
          "max" = 22
          "min" = 22
        }
      },
      {
        # rule 7
        protocol  = "6"
        source    = "0.0.0.0/0"
        stateless = "false"

        tcp_options {
          "max" = 22
          "min" = 22
        }
      },
      {
        # rule 8
        protocol  = "6"
        source    = "0.0.0.0/0"
        stateless = "false"

        tcp_options {
          "max" = 32767
          "min" = 3000
        }
      },
    ]
}
