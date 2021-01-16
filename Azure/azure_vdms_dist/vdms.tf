#-----------------------------------------------------------------------------------------------------------------
# Create spoke1 resource group, spoke1 VNET, VNET peering, UDR, internal LB, (2) VMs 

resource "azurerm_network_security_group" "vdms" {
  name                     = "${var.global_prefix}-ubuntu-nsg"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location

  security_rule {
    name                       = "local-vnet-inbound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.vnet_cidr
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "vdms_linux" {
  name                      ="${var.global_prefix}-ubuntu-nic0"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = module.vnet.subnet_ids[3]
    private_ip_address_allocation = "Static"
    private_ip_address            = var.linux_ip
  }
}

resource "azurerm_network_interface_security_group_association" "vdms_linux" {
  network_interface_id      = azurerm_network_interface.vdms_linux.id
  network_security_group_id = azurerm_network_security_group.vdms.id

  depends_on = [
    azurerm_virtual_machine.vdms_linux
  ]

}

resource "azurerm_virtual_machine" "vdms_linux" {
  name                             ="${var.global_prefix}-ubuntu-vm"
  resource_group_name              = azurerm_resource_group.main.name
  location                         = azurerm_resource_group.main.location
  network_interface_ids            = [azurerm_network_interface.vdms_linux.id]
  vm_size                          = var.linux_vm_size
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.linux_publisher
    offer     = var.linux_offer
    sku       = var.linux_sku
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.global_prefix}-ubuntu-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.global_prefix}-ubuntu-os"
    admin_username = var.vm_username
    admin_password = var.vm_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_network_interface" "vdms_windows" {
  name                      ="${var.global_prefix}-win-nic0"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = module.vnet.subnet_ids[3]
    private_ip_address_allocation = "Static"
    private_ip_address            = var.windows_ip

  }
}

resource "azurerm_network_interface_security_group_association" "vdms_windows" {
  network_interface_id      = azurerm_network_interface.vdms_windows.id
  network_security_group_id = azurerm_network_security_group.vdms.id
  
  depends_on = [
    azurerm_virtual_machine.vdms_windows
  ]

}

resource "azurerm_virtual_machine" "vdms_windows" {
  name                             = "${var.global_prefix}-win-vm"
  resource_group_name              = azurerm_resource_group.main.name
  location                         = azurerm_resource_group.main.location
  network_interface_ids            = [azurerm_network_interface.vdms_windows.id]
  vm_size                          = var.windows_vm_size
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.windows_publisher
    offer     = var.windows_offer
    sku       = var.windows_sku
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.global_prefix}-win-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.global_prefix}-win-os"
    admin_username = var.vm_username
    admin_password = var.vm_password
  }

   os_profile_windows_config {
     enable_automatic_upgrades = false
   }
}

