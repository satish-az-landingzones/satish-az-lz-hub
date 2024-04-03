resource "azurerm_public_ip" "bastion" {
  name                = "hub_bastion_pip"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

data "azurerm_subnet" "azure_bastion_subnet" {
  depends_on           = [azurerm_network_security_group.hub]
  name                 = "AzureBastionSubnet"
  virtual_network_name = azurerm_virtual_network.hub.name
  resource_group_name  = azurerm_resource_group.hub.name
}

resource "azurerm_bastion_host" "bastion" {
  name                = "hub_bastion"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = data.azurerm_subnet.azure_bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}