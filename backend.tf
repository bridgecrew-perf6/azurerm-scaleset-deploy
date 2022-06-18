terraform {
  backend "remote" {
    # Terraform Cloud
    organization = "danib-tfcloud"

    workspaces {
      name = "azurerm-scaleset-deploy"
    }
  }
}
