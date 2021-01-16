variable location {
  description = "Enter a location"
}

variable environment {
  description = "Environment variable to use Azure Gov (value: usgovernment) or Azure commercial (value: null)"
  default     = "usgovernment" 
}

variable global_prefix {
  description = "Prefix to add to resource group name"
}

variable fw_prefix {
  description = "Prefix to add to all resources added in the firewall resource group"
  default     = ""
}

variable fw_license {
  description = "VM-Series license: byol, bundle1, or bundle2"
  # default = "byol"   
  # default = "bundle1"  
  # default = "bundle2"
}

#-----------------------------------------------------------------------------------------------------------------
# VM-Series variables

variable fw_vm_count {
}

variable fw_nsg_prefix {
}

variable fw_panos {
}

variable vm_username {
}

variable vm_password {
}

variable fw_internal_lb_ip {
}


#-----------------------------------------------------------------------------------------------------------------
# Transit VNET variables

variable vnet_prefix {
}

variable vnet_cidr {
}

variable vnet_subnet_names {
  type = list(string)
}

variable vnet_subnet_cidrs {
  type = list(string)
}

#-----------------------------------------------------------------------------------------------------------------
# Spoke variables
variable linux_vm_size {}
variable linux_publisher {}
variable linux_offer {}
variable linux_sku {}
variable linux_ip {}

variable windows_vm_size {}
variable windows_publisher {}
variable windows_offer {}
variable windows_sku {}
variable windows_ip {}

#-----------------------------------------------------------------------------------------------------------------
# Azure environment variables

# variable client_id {
#   description = "Azure client ID"
# }

# variable client_secret {
#   description = "Azure client secret"
# }

# variable subscription_id {
#   description = "Azure subscription ID"
# }

# variable tenant_id {
#   description = "Azure tenant ID"
# }