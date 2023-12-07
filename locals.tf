locals {
  vpc_id_parts        = split(":", var.spoke_module.spoke_gateway.vpc_id)
  resource_group_name = local.vpc_id_parts[1]
  vnet_name           = local.vpc_id_parts[0]
  vnet_cidr           = element(data.azurerm_virtual_network.vnet.address_space, 0)

  spoke_gw_name      = var.spoke_module.spoke_gateway.gw_name
  spoke_location     = data.azurerm_virtual_network.vnet.location
  base_prefix_length = split("/", local.vnet_cidr)[1]
  additional_bits    = var.subnet_prefix_length - local.base_prefix_length

  subnets = { for i in range(1, var.subnet_count + 1) :
    format("wkld_sub_%d", i) => cidrsubnet(local.vnet_cidr, local.additional_bits, i)
  }
}