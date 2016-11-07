# Create nic and tie it to the resource group

resource "azurerm_public_ip" "publicIP" {
  name                         = "asoteloTestPublicIp1"
  location                     = "centralus"
  resource_group_name          = "${azurerm_resource_group.asoteloterra1.name}"
  public_ip_address_allocation = "dynamic"

  tags {
    environment = "test"
  }
}

# Tie to resource group and connect public address ip ID to public ip interface

resource "azurerm_network_interface" "nicID" {
  name                = "asotelonic1"
  location            = "centralus"
  resource_group_name = "${azurerm_resource_group.asoteloterra1.name}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.subnet1.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.publicIP.id}"
  }
}
