# Terraform Module - Aviatrix Subnet Group Generator

## Description

Given Aviatrix Spoke Gateway module name and Aviatrix Transit Gateway (with Firenet) name, subnet count and prefix length, creates private subnets, Aviatrix subnet groups (with a single subnet in each subnet group) and Firenet associations for the generated subnet groups.

## Usage Examples

### Minimal Configuration

```hcl
module "subnets_groups_firenetpolicy" {
  source = "./modules/subnet-group-generator"

  spoke_module            = module.euw_spoke_1
  transit_firenet_gw_name = module.euw_transit.transit_gateway.gw_name
}
```

### Configuration Defining Subnet Count and Prefix Length

```hcl
module "subnets_groups_firenetpolicy" {
  source = "./modules/subnet-group-generator"

  spoke_module            = module.euw_spoke_1
  transit_firenet_gw_name = module.euw_transit.transit_gateway.gw_name
  subnet_count = 6
  subnet_prefix_length = 26
}
```

## Variables

The following variables are required:

key | value
:--- | :---
spoke_module | Name of the Aviatrix spoke gateway module in the VNET in which these subnets should be created
transit_firenet_gw_name | Name of the Aviatrix transit gateway to which the spoke is attached

The following variables are required:

key | value
:--- | :---
subnet_count | Number of subnets to create (default: 4)
subnet_prefix_length | Prefix length of the subnets being created (default: 27)
