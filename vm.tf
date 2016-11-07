# Create virtal machine and define image to install on VM 

variable "admin_username" {}

variable "admin_password" {}

resource "azurerm_virtual_machine" "vmtest" {
  name                  = "asotvm01"
  location              = "centralus"
  resource_group_name   = "${azurerm_resource_group.asoteloterra1.name}"
  network_interface_ids = ["${azurerm_network_interface.nicID.id}"]
  vm_size               = "Standard_A2"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2012-R2-Datacenter"
    version   = "latest"
  }

  # Assign vhd blob storage and create a profile

  storage_os_disk {
    name          = "osdisk0"
    vhd_uri       = "${azurerm_storage_account.stacc1.primary_blob_endpoint}${azurerm_storage_container.vmdisk.name}/myosdisk1.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }
  storage_data_disk {
    name          = "datadisk0"
    vhd_uri       = "${azurerm_storage_account.stacc1.primary_blob_endpoint}${azurerm_storage_container.vmdisk.name}/datadisk0.vhd"
    disk_size_gb  = "1023"
    create_option = "empty"
    lun           = 0
  }
  os_profile {
    computer_name  = "asotvm01"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }
}

# Define security object and create inbound and outbound rulesets

resource "azurerm_network_security_group" "sgtest" {
  name                = "asotSecurityGroup1"
  location            = "centralus"
  resource_group_name = "${azurerm_resource_group.asoteloterra1.name}"
}

resource "azurerm_network_security_rule" "srtest" {
  name                        = "asotRule1"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "3389"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.asoteloterra1.name}"
  network_security_group_name = "${azurerm_network_security_group.sgtest.name}"
}

resource "azurerm_network_security_rule" "inbound" {
  name                        = "inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "3389"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.asoteloterra1.name}"
  network_security_group_name = "${azurerm_network_security_group.sgtest.name}"
}

output "VM_Name" {
  value = "${azurerm_virtual_machine.vmtest.name}"
}

output "public_ip" {
  value = "${azurerm_public_ip.publicIP.public_ip}"
}
