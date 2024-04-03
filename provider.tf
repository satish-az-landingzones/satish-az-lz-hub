# Configure Terraform to set the required AzureRM provider
# version and features{} block.

terraform {
  cloud {
    organization = "tf-az-landingzone"

    workspaces {
      name = "tf-workspace-az-hub"
    }
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.74.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  alias           = "spoke"
  subscription_id = "caa318eb-1d1b-4015-b096-195726de1378"

}