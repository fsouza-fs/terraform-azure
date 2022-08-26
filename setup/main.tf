provider "azurerm" {
  features {}
}

resource "random_pet" "rg-name" {
  prefix    = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  name      = random_pet.rg-name.id
  location  = var.resource_group_location
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = module.Network.netinterfc.id
  network_security_group_id = module.SecurityGroup.secgroup.id
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "SecurityGroup" {
  source = "../modules/SecurityGroup"
  recgplocation = azurerm_resource_group.rg.location
  recgpname = azurerm_resource_group.rg.name
}

module "VirtualMachine" {
  source = "../modules/VirtualMachine"
  recgplocation = azurerm_resource_group.rg.location
  recgpname = azurerm_resource_group.rg.name
  netinterfc = module.Network.netinterfc.id
  pub_key = tls_private_key.example_ssh.public_key_openssh
  priv_key = tls_private_key.example_ssh.private_key_openssh
  stg_account = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
}

module "Network" {
  source = "../modules/Network"
  recgplocation = azurerm_resource_group.rg.location
  recgpname = azurerm_resource_group.rg.name
}
