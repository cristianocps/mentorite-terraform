# Copyright (c) 2023, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

## JAVA specific variables and locals

# Application configuration - SSL properties
variable "use_default_ssl_configuration" {
  type = bool
  default = false
}
variable "port_property" {
  type = string
  default = "server.port"
}
variable "keystore_property" {
  type = string
  default = "server.ssl.key-store"
}
variable "key_alias_property" {
  type = string
  default = "server.ssl.key-alias"
}
variable "keystore_password_property" {
  type = string
  default = "server.ssl.key-store-password"
}
variable "keystore_type_property" {
  type = string
  default = "server.ssl.key-store-type"
}

variable "application_type" {
  type = string
  default = "not selected"
  description = "application type : JAR, WAR"
}

variable "vm_options" {
  type = string
  description = "VM options"  
  default = ""
}

locals {
 
}