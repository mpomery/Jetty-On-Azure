# Jetty On Azure
Playbooks to set up a Jetty HTTP Server on Azure.

## Prerequisites

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [Terraform installed and configured to work with Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)
- You already have a resource group that exists called "temp-test" (or you modify the tf file to your own resource group)

## How To

- Run Terraform to deploy a VM to Azure, configure it and secure it
- Run Ansible to configure Jetty on the spun up Azure VM
