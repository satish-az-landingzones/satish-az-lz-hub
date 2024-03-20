data "azurerm_management_group" "hub" {
  name = "es-connectivity"
}

data "azurerm_billing_mca_account_scope" "hub" {
  billing_account_name = "c3e4d4fd-a248-5faf-65ad-faca35ed9980:cb1a0f0b-ef62-4e9c-ac1d-6b1159aadeec_2019-05-31"
  billing_profile_name = "5MI2-CB77-BG7-PGB"
  invoice_section_name = "TPUJ-JTMZ-PJA-PGB"
}

resource "azurerm_subscription" "hub" {
  subscription_name = "Hub Subscription 2"
  billing_scope_id  = data.azurerm_billing_mca_account_scope.hub.id
}


resource "azurerm_management_group_subscription_association" "hub" {
  management_group_id = data.azurerm_management_group.hub.id
  subscription_id     = azurerm_subscription.hub.subscription_id
}

resource "azurerm_resource_group" "hub" {
  name     = "hub-resources"
  location = var.default_location
}

resource "azurerm_network_security_group" "hub" {
  name                = "hub-security-group"
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

  tags = {
    environment = "Production"
  }
}