provider "azurerm" {
}

# Create resource group to contain everything
resource "azurerm_resource_group" "jetty_resource_group" {
    name     = "temp-test"
    location = "centralus"

    tags = {
        environment = "JettyServer"
    }
}

# Create a virtual network to hold our servers
resource "azurerm_virtual_network" "jetty_network" {
    name                = "jettyVnet"
    address_space       = ["10.0.0.0/16"]
    location            = "centralus"
    resource_group_name = "${azurerm_resource_group.jetty_resource_group.name}"

    tags = {
        environment = "JettyServer"
    }
}

# Assign a subnet for our Jetty servers ti live in
resource "azurerm_subnet" "jetty_subnet" {
    name                 = "jettySubnet"
    resource_group_name  = "${azurerm_resource_group.jetty_resource_group.name}"
    virtual_network_name = "${azurerm_virtual_network.jetty_network.name}"
    address_prefix       = "10.0.2.0/24"
}

# Get a public IP to give our Jetty Server
resource "azurerm_public_ip" "jetty_public_ip" {
    name                         = "jettyPublicIP"
    location                     = "centralus"
    resource_group_name          = "${azurerm_resource_group.jetty_resource_group.name}"
    allocation_method            = "Dynamic"

    tags = {
        environment = "JettyServer"
    }
}

# Configure our security group for SSH and Jetty (TCP 8080)
resource "azurerm_network_security_group" "jetty_sg" {
    name                = "JettySecurityGroup"
    location            = "centralus"
    resource_group_name = "${azurerm_resource_group.jetty_resource_group.name}"

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "Jetty"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8080"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "JettyServer"
    }
}


# Create a NIC to give our public Jetty Server
resource "azurerm_network_interface" "jetty_nic" {
    name                = "jettyNIC"
    location            = "centralus"
    resource_group_name = "${azurerm_resource_group.jetty_resource_group.name}"
    network_security_group_id = "${azurerm_network_security_group.jetty_sg.id}"

    ip_configuration {
        name                          = "jettyNicConfiguration"
        subnet_id                     = "${azurerm_subnet.jetty_subnet.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.jetty_public_ip.id}"
    }

    tags = {
        environment = "JettyServer"
    }
}

resource "azurerm_virtual_machine" "jetty_vm" {
    name                  = "jettyVM"
    location              = "centralus"
    resource_group_name   = "${azurerm_resource_group.jetty_resource_group.name}"
    network_interface_ids = ["${azurerm_network_interface.jetty_nic.id}"]
    vm_size               = "Standard_DS1_v2"

    storage_os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "Progreso"
        admin_username = "jettyadmin"
        admin_password = "qE4WXhz8H@U0"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }
    
    tags = {
        environment = "JettyServer"
    }
}
