#-----------------------------------------------------------------------------------------------------------------
# Create VM-Series VNET

module "vnet" {
  source              = "./modules/vnet/"
  name                = "${var.global_prefix}-${var.vnet_prefix}-vnet"
  vnet_cidr           = var.vnet_cidr
  subnet_names        = var.vnet_subnet_names
  subnet_cidrs        = var.vnet_subnet_cidrs
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

}

resource "azurerm_route_table" "vnet" {
  name                = "${var.global_prefix}-${var.vnet_prefix}-rtb"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  route {
    name                   = "default-udr"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.fw_internal_lb_ip
  }

  route {
    name                   = "local-udr"
    address_prefix         = var.vnet_cidr
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.fw_internal_lb_ip
  }
}

resource "azurerm_subnet_route_table_association" "example" {
  subnet_id      = module.vnet.subnet_ids[3]
  route_table_id = azurerm_route_table.vnet.id
}