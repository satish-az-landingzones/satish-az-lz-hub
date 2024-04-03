data "azurerm_virtual_network" "spoke" {
  name                = "spoke-network"
  resource_group_name = "spoke-resources"
}
 
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "hub_to_spoke"
  resource_group_name       = azurerm_resource_group.hub.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = data.azurerm_virtual_network.spoke.id
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "spoke_to_hub"
  resource_group_name       = "spoke-resources"
  virtual_network_name      = data.azurerm_virtual_network.spoke.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id
}