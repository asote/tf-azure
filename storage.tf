resource "azurerm_storage_container" "vmdisk" {
  name                  = "vhds"
  resource_group_name   = "${azurerm_resource_group.asoteloterra1.name}"
  storage_account_name  = "${azurerm_storage_account.stacc1.name}"
  container_access_type = "private"
}
