output "subnets" {
  value = azurerm_subnet.this
}

output "subnet_groups" {
  value = aviatrix_spoke_gateway_subnet_group.this
}