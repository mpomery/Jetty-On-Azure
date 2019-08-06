# Jetty On Azure
Playbooks to set up a Jetty HTTP Server on Azure.

## Prerequisites

- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [Terraform](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)

## How To

- Run Terraform to deploy a VM to Azure, configure it and secure it
- Run Ansible to configure Jetty on the spun up Azure VM
