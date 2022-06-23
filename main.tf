## Commenting everything because the workflow doesnt allow an external destroy command
## The source code must be the single source of truth


resource "azurerm_resource_group" "ms_common_latest_rg" {
  name = var.MS_COMMON_LATEST_RG
  location = var.LOCATION
}

resource "azurerm_virtual_network" "ms_common_latest_vnet" {
  name                = var.MS_COMMON_LATEST_VNET
  resource_group_name = azurerm_resource_group.ms_common_latest_rg.name
  location            = azurerm_resource_group.ms_common_latest_rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "ms_common_latest_subnet" {
  name                 = var.SUBNET_NAME
  resource_group_name  = azurerm_resource_group.ms_common_latest_rg.name
  virtual_network_name = azurerm_virtual_network.ms_common_latest_vnet.name
  address_prefixes     = ["10.0.0.0/24"]
  service_endpoints    = [
    "Microsoft.KeyVault"
  ]
}

resource "azurerm_windows_virtual_machine_scale_set" "ms_common_latest_vmss" {
  name                = var.MS_COMMON_LATEST_SCALESET_NAME
  resource_group_name = azurerm_resource_group.ms_common_latest_rg.name
  location            = azurerm_resource_group.ms_common_latest_rg.location
  sku                 = "Standard_D2_v2"
  instances           = 2
  computer_name_prefix = "at"
  admin_password      = var.VM_INSTANCE_ADMIN_PASSWORD
  admin_username      = "WaiBuildAdmin"
  overprovision = false
  timeouts {
    create = "2h"
    delete = "1h"
  }

    lifecycle {
    ignore_changes = [
      # Ignore changes to instances, because Azure DevOps is going to
      # manage this setting automatically when using the scale set.
      instances,
      tags,
    ]
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter-Server-Core"
    version   = "latest"
  }

  #source_image_id = "/subscriptions/07ca8529-f92b-4aa9-b3b1-2a4a15f624f4/resourceGroups/MS-DevOps-ScaleSets-RG/providers/Microsoft.Compute/galleries/MS.Gallery/images/PC-DMIS-Latest/versions/1.1.0"
  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadOnly"
    # diff_disk_settings {
    #   option = "Local"
    # }
  }

  network_interface {
    name    = "${var.MS_COMMON_LATEST_SCALESET_NAME}-nic"
    primary = true

    ip_configuration {
      name      = var.SUBNET_NAME
      primary   = true
      subnet_id = azurerm_subnet.ms_common_latest_subnet.id
    }
  }
}
