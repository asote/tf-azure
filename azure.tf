# Azure terraform test

# References

# https://www.terraform.io/docs/providers/azurerm/index.html

# http://arjenwilly.github.io/terraform.html

# Configure the Azure ARM provider
variable "ARM_SUBSCRIPTION_ID" {}

variable "ARM_CLIENT_ID" {}

variable "ARM_CLIENT_SECRET" {}

variable "ARM_TENANT_ID" {}

provider "azurerm" {
  subscription_id = "${var.ARM_SUBSCRIPTION_ID}"
  client_id       = "${var.ARM_CLIENT_ID}"
  client_secret   = "${var.ARM_CLIENT_SECRET}"
  tenant_id       = "${var.ARM_TENANT_ID}"
}

# Create a resource group
resource "azurerm_resource_group" "asoteloterra1" {
  name     = "asoteloterra1"
  location = "central us"
}

# Create a virtual network
resource "azurerm_virtual_network" "network" {
  name                = "asotestnet"
  address_space       = ["10.0.0.0/16"]
  location            = "Central US"
  resource_group_name = "${azurerm_resource_group.asoteloterra1.name}"
}

# Create subnets
resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = "${azurerm_resource_group.asoteloterra1.name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name  = "${azurerm_resource_group.asoteloterra1.name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_subnet" "subnet3" {
  name                 = "subnet3"
  resource_group_name  = "${azurerm_resource_group.asoteloterra1.name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
  address_prefix       = "10.0.3.0/24"
}

resource "azurerm_storage_account" "stacc1" {
  name                = "asotelostacc"
  resource_group_name = "${azurerm_resource_group.asoteloterra1.name}"

  location     = "centralus"
  account_type = "Standard_GRS"

  tags {
    environment = "test"
  }
}

output "resource_group" {
  value = "${azurerm_resource_group.asoteloterra1.name}"
}

output "storage_account" {
  value = "${azurerm_storage_account.stacc1.name}"
}

output "virtualnet" {
  value = "${azurerm_virtual_network.network.name}"
}
