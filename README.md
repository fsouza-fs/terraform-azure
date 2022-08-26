# terraform-azure
Terraform template project for AZURE Virtual Machines

# Downloads
Download and install [Terraform](https://www.terraform.io/downloads).

Download and install [Azure Command-Line Interface](https://docs.microsoft.com/en-us/cli/azure).

After installing azure cli, login to your azure account with:
```console
az login
```

# Setup
cd into setup/ directory
Create a .env file containing the following variables:

```shellscript
export TF_VAR_ARM_SUBSCRIPTION_ID="<YOUR_SUBSCRIPTION_ID>"
export TF_VAR_ARM_TENANT_ID="<YOUR_TENANT_ID>"
export TF_VAR_ARM_CLIENT_ID="<YOUR_CLIENT_ID>"
export TF_VAR_ARM_CLIENT_SECRET="<YOUR_CLIENT_SECRET>"
```

Run the following command for the variables to take effect:
```console
source variables.env
```

If you don't know your credentials, follow this guide to obtain them:
[Microsoft Docs](https://docs.microsoft.com/pt-br/azure/developer/terraform/get-started-cloud-shell-bash?tabs=bash#authenticate-to-azure-via-a-microsoft-account)


# Run
Initialize terraform with:
```console
terraform init
```
To see what actions will be executed before they are run, use:
```console
terraform plan
```
Finally apply the configurations:
```console
terraform apply
```

# Accessing the virtual machine
After running, terraform will save the vm details.
First, save the private key to a file and give the appropriate permissions:
```console
terraform output -raw tls_private_key > id_rsa
chmod 600 id_rsa
```
Get the vm ip address:
```console
terraform output public_ip_address
```
You can now access the vm with:
```console
ssh -i id_rsa azureuser@<public_ip_address>
```

Visit the [Microsoft Guide](https://docs.microsoft.com/pt-br/azure/developer/terraform/create-linux-virtual-machine-with-infrastructure) for details.

