#-----------------------------------------------------------------------------------------------------------------
# Create storage account and file share for bootstrapping

resource "random_string" "main" {
  length      = 15
  min_lower   = 10
  min_numeric = 5
  special     = false
}

resource "azurerm_storage_account" "vmseries" {
  name                     = substr("bootstrap${random_string.main.result}", 0, 15)
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

module "vmseries_fileshare" {
  source               = "./modules/azure_bootstrap/"
  name                 = "${var.global_prefix}-${var.fw_prefix}-bootstrap"
  quota                = 1
  storage_account_name = azurerm_storage_account.vmseries.name
  storage_account_key  = azurerm_storage_account.vmseries.primary_access_key
  local_file_path      = "bootstrap_files/vmseries/"
}


#-----------------------------------------------------------------------------------------------------------------
# Create VM-Series.  For every fw_name entered, an additional VM-Series instance will be deployed.

module "vmseries" {
  source                    = "./modules/vmseries/"
  name                      = "${var.global_prefix}-${var.fw_prefix}-vm"
  resource_group_name       = azurerm_resource_group.main.name
  location                  = azurerm_resource_group.main.location
  vm_count                  = 2
  username                  = var.vm_username
  password                  = var.vm_password
  panos                     = var.fw_panos
  license                   = var.fw_license
  nsg_prefix                = var.fw_nsg_prefix
  avset_name                = "${var.fw_prefix}-avset"
  subnet_mgmt               = module.vnet.subnet_ids[0]
  subnet_untrust            = module.vnet.subnet_ids[1]
  subnet_trust              = module.vnet.subnet_ids[2]
  nic0_public_ip            = true
  nic1_public_ip            = false
  nic2_public_ip            = false
  nic1_backend_pool_id      = [module.common_extlb.backend_pool_id]
  nic2_backend_pool_id      = [module.common_intlb.backend_pool_id]
  bootstrap_storage_account = azurerm_storage_account.vmseries.name
  bootstrap_access_key      = azurerm_storage_account.vmseries.primary_access_key
  bootstrap_file_share      = module.vmseries_fileshare.file_share_name
  bootstrap_share_directory = "None"

  depends_on = [
    module.vmseries_fileshare
  ]
}


#-----------------------------------------------------------------------------------------------------------------
# Create public load balancer.  Load balancer uses firewall's untrust interfaces as its backend pool.

module "common_extlb" {
  source                = "./modules/lb/"
  name                  = "${var.global_prefix}-${var.fw_prefix}-public-lb"
  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  type                  = "public"
  sku                   = "Standard"
  probe_ports           = [22]
  frontend_ports        = [22, 3389]
  backend_ports         = [22, 3389]
  protocol              = "Tcp"
  network_interface_ids = module.vmseries.nic1_id
}

#-----------------------------------------------------------------------------------------------------------------
# Create internal load balancer. Load balancer uses firewall's trust interfaces as its backend pool

module "common_intlb" {
  source                = "./modules/lb/"
  name                  = "${var.global_prefix}-${var.fw_prefix}-internal-lb"
  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  type                  = "private"
  sku                   = "Standard"
  probe_ports           = [22]
  frontend_ports        = [0]
  backend_ports         = [0]
  protocol              = "All"
  subnet_id             = module.vnet.subnet_ids[2]
  private_ip_address    = var.fw_internal_lb_ip
  network_interface_ids = module.vmseries.nic2_id
}

