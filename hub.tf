resource "azurerm_resource_group" "hub" {
  name     = "hub-resources"
  location = var.default_location
}

resource "azurerm_network_security_group" "hub" {
  name                = "hub-security-group"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
}

resource "azurerm_network_security_group" "sg_hub_bastion" {
  name                = "bastion-security-group"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  security_rule {
    name                       = "AllowAzureBastion"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "AzureBastion"
  }
}

resource "azurerm_virtual_network" "hub" {
  name                = "hub-network"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.hub.id
  }

  subnet {
    name           = "AzureBastionSubnet"
    address_prefix = "10.0.3.0/26"
    security_group = azurerm_network_security_group.sg_hub_bastion.id
  }

  tags = {
    environment = "Production"
  }
}

