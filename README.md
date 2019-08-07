# Jetty On Azure

What This Does

- Configures an Azure enviroment
- Creates a VM in Azure
- Configures [Jetty](https://www.eclipse.org/jetty/) on that VM


## Prerequisites

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [Terraform installed and configured to work with Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)
- sshpass installed

## How To

- Clone this Repo
- Ensure you have Terraform installed and [configured](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure#configure-terraform-environment-variables).
- Run `terraform init` to ensure terraform is initialized
- Run `terraform apply` to deploy resources into azure
- Log in to the Azure console and find the Jetty Public IP (Mine was `13.67.225.169`)
- Update the Ansible `hosts` file to have your server listed under `[jettyservers]`
- Run `ansible-playbook jetty-server -i hosts --ask-pass` to configure the Jetty Server
- Enter the password that you set for the VM in jetty.tf
- Visit your site to see Jetty in action
