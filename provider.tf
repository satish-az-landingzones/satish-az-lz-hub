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