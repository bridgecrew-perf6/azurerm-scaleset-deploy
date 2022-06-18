
variable "MS_COMMON_LATEST_RG" {
  type = string
}
variable "LOCATION" {
  type = string
  default = "uksouth"
}
variable "VM_INSTANCE_ADMIN_PASSWORD" {
  type = string
}

variable "MS_COMMON_LATEST_VNET" {
  type = string
}
variable "SUBNET_NAME" {
  type = string
}

variable "MS_COMMON_LATEST_SCALESET_NAME" {
  type = string
}
