#fw_license   = "byol"                                                       # Uncomment 1 fw_license to select VM-Series licensing mode
#fw_license   = "bundle1"
fw_license    = "bundle2"
global_prefix = "vdms"

location        = "eastus"        // commercial region  
//location      = "usgovvirgina"  // uncomment to deploy into government region    
//environment   = "usgovernment"  // uncomment to deploy into Azure Gov

# -----------------------------------------------------------------------
# VM-Series resource group variables
fw_prefix               = "vmseries"                                         # Adds prefix name to all resources created in the firewall resource group
fw_vm_count             = 1
fw_panos                = "10.0.1"
fw_nsg_prefix           = "0.0.0.0/0"
fw_internal_lb_ip       = "10.0.2.100"

# -----------------------------------------------------------------------
# Transit resource group variables
vnet_prefix          = "security"                                         # Adds prefix name to all resources created in the transit vnet's resource group
vnet_cidr            = "10.0.0.0/16"
vnet_subnet_names    = ["mgmt", "untrust", "trust", "vdms"]
vnet_subnet_cidrs    = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

# -----------------------------------------------------------------------
# VDMS resource group variables                                      # Adds prefix name to all resources created in spoke1's resource group
linux_vm_size           = "Standard_B1s"
linux_publisher         = "Canonical"
linux_offer             = "UbuntuServer"
linux_sku               = "16.04-LTS"
linux_ip                = "10.0.3.4"

windows_vm_size         = "Standard_DS1_v2"
windows_publisher       = "MicrosoftWindowsServer"
windows_offer           = "WindowsServer"
windows_sku             = "2016-Datacenter"
windows_ip              = "10.0.3.5"

vm_username             = "paloalto"
vm_password             = "Pal0Alt0@123"



