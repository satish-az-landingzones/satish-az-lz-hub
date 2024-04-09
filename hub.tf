resource "azurerm_resource_group" "hub" {
  name     = "hub-resources"
  location = var.default_location
}

resource "azurerm_network_security_group" "hub" {
  name                = "hub-security-group"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
}

resource "azurerm_network_security_group" "bastion" {
  name                = "bastion-security-group"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
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

#   subnet {
#     name           = "AzureBastionSubnet"
#     address_prefix = "10.0.3.0/26"
#     security_group = azurerm_network_security_group.bastion.id
#   }

  tags = {
    environment = "Production"
  }
}

# data "azurerm_subnet" "bastion_subnet" {
#   depends_on           = [azurerm_virtual_network.hub]
#   name                 = "AzureBastionSubnet"
#   virtual_network_name = azurerm_virtual_network.hub.name
#   resource_group_name  = azurerm_resource_group.hub.name
# }

resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.3.0/26"]
}


resource "azurerm_subnet_network_security_group_association" "subnet" {
  subnet_id                 = azurerm_subnet.bastion_subnet.id
  network_security_group_id = azurerm_network_security_group.bastion.id

  depends_on = [azurerm_network_security_rule.allow_https_Inbound,
    azurerm_network_security_rule.allow_gateway_manager_Inbound,
    azurerm_network_security_rule.allow_sshrdp_Outbound,
  azurerm_network_security_rule.allow_azurecloud_Outbound]
}


resource "azurerm_network_security_rule" "allow_https_Inbound" {
  name                        = "AllowHttpsInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.hub.name
  network_security_group_name = azurerm_network_security_group.bastion.name
}

resource "azurerm_network_security_rule" "allow_gateway_manager_Inbound" {
  name                        = "AllowGatewayManagerInbound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "GatewayManager"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.hub.name
  network_security_group_name = azurerm_network_security_group.bastion.name
}

resource "azurerm_network_security_rule" "allow_sshrdp_Outbound" {
  name                        = "AllowSshRdpOutbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["22", "3389"]
  source_address_prefix       = "*"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.hub.name
  network_security_group_name = azurerm_network_security_group.bastion.name
}

resource "azurerm_network_security_rule" "allow_azurecloud_Outbound" {
  name                        = "AllowAzureCloudOutbound"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "AzureCloud"
  resource_group_name         = azurerm_resource_group.hub.name
  network_security_group_name = azurerm_network_security_group.bastion.name
}