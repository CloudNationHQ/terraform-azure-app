module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 0.1"

  groups = {
    demo = {
      name   = module.naming.resource_group.name
      region = "westeurope"
    }
  }
}

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 3.0"

  naming = local.naming

  vnet = {
    name           = module.naming.virtual_network.name
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    cidr           = ["10.18.0.0/16"]

    subnets = {
      sn1 = {
        cidr = ["10.18.1.0/24"]
        nsg  = {}
        delegations = {
          web = {
            name = "Microsoft.Web/serverFarms"
            actions = [
              "Microsoft.Network/virtualNetworks/subnets/action"
            ]
          }
        }
      }
    }
  }
}

module "appservice" {
  source  = "cloudnationhq/plan/azure"
  version = "~> 1.0"

  resource_group = module.rg.groups.demo.name
  location       = module.rg.groups.demo.location

  plans = {
    web = {
      name     = module.naming.app_service_plan.name
      os_type  = "Linux"
      sku_name = "P0v3"
    }
  }
}

module "webapp" {
  source  = "cloudnationhq/web/azure"
  version = "~> 1.0"

  resource_group = module.rg.groups.demo.name
  location       = module.rg.groups.demo.location

  instance = {
    type                      = "linux"
    name                      = "app-demo-dev-xaeso"
    service_plan_id           = module.appservice.plans.web.id
    virtual_network_subnet_id = module.network.subnets.sn1.id

    site_config = {
      websockets_enabled     = true
      vnet_route_all_enabled = true
    }
  }
}
