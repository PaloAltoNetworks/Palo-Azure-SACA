#-----------------------------------------------------------------------------------------------------------------
# Outputs to terminal

output "RDP-IP" {
  value = module.common_extlb.public_ip[0]
}

output "MGMT-FW1" {
  value = "https://${module.vmseries.nic0_public_ip[0]}"
}

output "MGMT-FW2" {
  value = "https://${module.vmseries.nic0_public_ip[1]}"
}

output "SPOKE2-SSH" {
  value = "ssh ${var.vm_username}@${module.common_extlb.public_ip[0]}"
}
