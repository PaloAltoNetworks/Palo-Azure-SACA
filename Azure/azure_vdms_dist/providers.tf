terraform {
  required_version = "~> 0.14"
}

provider "azurerm" {
  #version         = "= 1.41"  "~> 2.40.0"
  # subscription_id = var.subscription_id
  # client_id       = var.client_id
  # client_secret   = var.client_secret
  # tenant_id       = var.tenant_id
  environment     = var.environment
  features {}
}


resource "azurerm_resource_group" "main" {
  name     = "${var.global_prefix}-rg"
  location = var.location
}