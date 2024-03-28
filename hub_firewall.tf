resource "azurerm_resource_group" "hub_fw_rg" {
  name     = "rg-fw-hub-dev-eastus-001"
  location = var.default_location
}

resource "azurerm_subnet" "hub_fw_subnet" {
  name                 = "fw-hub-subnet"
  resource_group_name  = azurerm_resource_group.hub_fw_rg.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.3.0/26"]
}

resource "azurerm_public_ip" "hub_fw_pip" {
  name                = "pip_fw_hub_dev_eastus_001"
  resource_group_name = azurerm_resource_group.hub_fw_rg.name
  location            = azurerm_resource_group.hub_fw_rg.location
  allocation_method   = "Static"
}

resource "azurerm_firewall" "hub_fw" {
  name                = "fw_hub_dev_eastus_001"
  location            = azurerm_resource_group.hub_fw_rg.location
  resource_group_name = azurerm_resource_group.hub_fw_rg.name
  sku_name            = "AZFW_Hub"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.hub_fw_subnet.id
    public_ip_address_id = azurerm_public_ip.hub_fw_pip.id
  }
}