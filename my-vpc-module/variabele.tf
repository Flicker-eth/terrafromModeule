variable "location" {
  description = "The location/region where the resources will be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group to create."
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network to create."
  type        = string
}

variable "address_space" {
  description = "The address space of the virtual network."
  type        = list(string)
}

variable "public_subnet_name" {
  description = "The name of the public subnet to create."
  type        = string
}

variable "public_subnet_prefix" {
  description = "The address prefix of the public subnet."
  type        = string
}

variable "private_subnet_name" {
  description = "The name of the private subnet to create."
  type        = string
}

variable "private_subnet_prefix" {
  description = "The address prefix of the private subnet."
  type        = string
}

variable "vm_name" {
  description = "The name of the virtual machine to create."
  type        = string
}

variable "vm_size" {
  description = "The size of the virtual machine."
  type        = string
}

variable "admin_username" {
  description = "The admin username of the virtual machine."
  type        = string
}

variable "admin_password" {
  description = "The admin password of the virtual machine."
  type        = string
}