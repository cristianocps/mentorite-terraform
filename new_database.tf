# Copyright (c) 2023, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

#create new database 
resource "oci_mysql_mysql_db_system" "database" {
  depends_on = [
    oci_core_subnet.db_oci_core_subnet,
    oci_core_network_security_group.db_nsg
  ]
  availability_domain         = var.autonomous_database_availabibility_domain
  shape_name                  = var.autonomous_database_shape_name
  admin_password              = var.autonomous_database_admin_password
  compartment_id              = var.compartment_id
  # db_name                     = var.autonomous_database_display_name
  display_name                = var.autonomous_database_display_name
  # data_storage_size_in_tbs    = var.data_storage_size_in_tbs
  # cpu_core_count              = var.ocpu_count
  # db_version                  = var.db_version
  # is_mtls_connection_required = (local.use-image ? false : true)
  # license_model               = var.db_license_model
  # Set subnet and nsg for private endpoint connection with app
  subnet_id = local.db_subnet_id
  # nsg_ids   = [oci_core_network_security_group.db_nsg[0].id]
}

output "mysql_db_system_id" {
  value = oci_mysql_mysql_db_system.database.id
}