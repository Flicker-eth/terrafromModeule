# Provider configuration
provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "my-resource-group"
  location = "westus2"
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "my-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  subnet {
    name           = "public-subnet"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "private-subnet"
    address_prefix = "10.0.2.0/24"
  }
}

# Cloud NAT
resource "azurerm_nat_gateway" "nat" {
  name                = "my-nat"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  public_ip_address_id = "${azurerm_public_ip.nat.id}"
  sku_name            = "Standard"

  subnet_id = "${azurerm_virtual_network.vnet.subnet_private.id}"
}

resource "azurerm_public_ip" "nat" {
  name                = "my-nat-pip"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  allocation_method   = "Static"
}

# Virtual Machine
resource "azurerm_network_interface" "nic" {
  name                = "my-nic"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "my-nic-ip"
    subnet_id                     = "${azurerm_virtual_network.vnet.subnet_private.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.nic.id}"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "my-vm"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = "Password1234!"

  network_interface_ids = [
    "${azurerm_network_interface.nic.id}",
  ]

  os_disk {
    name              = "my-os-disk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "myvm"
    admin_username = "adminuser"
    admin_password = "Password1234!"
  }
}

# Output
output "vm_private_ip" {
  value = "${azurerm_network_interface.nic.private_ip_address}"
}

output "vm_nat_public_ip" {
  value = "${azurerm_public_ip.nat.ip_address}"
}



