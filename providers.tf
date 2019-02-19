provider "oci" {
    region           = "${var.oci_region}"
    tenancy_ocid     = "${var.oci_tenancy_id}"
    user_ocid        = "${var.oci_user_id}"
    fingerprint      = "${var.oci_fingerprint}"
    private_key_path = "${var.oci_private_key_path}"
}