# Create the workload subnet(s)
resource "azurerm_subnet" "this" {
  for_each = local.subnets

  name                 = each.key
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.vnet_name
  address_prefixes     = [each.value]
}

# Create the route table with a blackhole route
resource "azurerm_route_table" "rt" {
  name                = "quad_zero_blackhole_route_table"
  location            = local.spoke_location
  resource_group_name = local.resource_group_name

  route {
    name           = "quad_zero_blackhole_route"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "None"
  }

  lifecycle {
    ignore_changes = [
      route
    ]
  }
}

# Associate the route table with the subnet(s)
resource "azurerm_subnet_route_table_association" "association" {
  for_each = azurerm_subnet.this

  subnet_id      = each.value.id
  route_table_id = azurerm_route_table.rt.id

  lifecycle {
    ignore_changes = [
      subnet_id,
      route_table_id
    ]
  }
}

# Create the subnet group(s)
resource "aviatrix_spoke_gateway_subnet_group" "this" {
  for_each = local.subnets

  name    = each.key
  gw_name = var.spoke_module.spoke_gateway.gw_name
  subnets = ["${each.value}~~${each.key}"]

  depends_on = [
    azurerm_subnet.this
  ]
}

# Attach the subnet group(s) to the firenet policy
resource "aviatrix_transit_firenet_policy" "this" {
  for_each = local.subnets

  transit_firenet_gateway_name = var.transit_firenet_gw_name
  inspected_resource_name      = "SPOKE_SUBNET_GROUP:${local.spoke_gw_name}~~${each.key}"

  depends_on = [
    aviatrix_spoke_gateway_subnet_group.this
  ]
}