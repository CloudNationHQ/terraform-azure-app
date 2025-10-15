module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.24"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 9.0"

  naming = local.naming

  vnet = {
    name                = module.naming.virtual_network.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    address_space       = ["10.18.0.0/16"]
    subnets = {
      sn1 = {
        address_prefixes = ["10.18.1.0/24"]
        nsg              = {}
      }
    }
  }
}

module "private_dns" {
  source  = "cloudnationhq/pdns/azure"
  version = "~> 4.0"

  resource_group_name = module.rg.groups.demo.name

  zones = {
    private = {
      web = {
        name = "privatelink.azurewebsites.net"
        virtual_network_links = {
          link1 = {
            virtual_network_id   = module.network.vnet.id
            registration_enabled = true
          }
        }
      }
    }
  }
}

module "privatelink" {
  source  = "cloudnationhq/pe/azure"
  version = "~> 2.0"

  resource_group_name = module.rg.groups.demo.name
  location            = module.rg.groups.demo.location

  endpoints = {
    web = {
      name      = module.naming.private_endpoint.name
      subnet_id = module.network.subnets.sn1.id

      private_dns_zone_group = {
        private_dns_zone_ids = [module.private_dns.private_zones.web.id]
      }

      private_service_connection = {
        private_connection_resource_id = module.webapp.instance.id
        subresource_names              = ["sites"]
      }
    }
  }
}

module "appservice" {
  source  = "cloudnationhq/plan/azure"
  version = "~> 3.0"

  resource_group_name = module.rg.groups.demo.name
  location            = module.rg.groups.demo.location

  plans = {
    web = {
      name     = module.naming.app_service_plan.name
      os_type  = "Linux"
      sku_name = "P1v3"
    }
  }
}

module "webapp" {
  source  = "cloudnationhq/app/azure"
  version = "~> 5.0"

  resource_group_name = module.rg.groups.demo.name
  location            = module.rg.groups.demo.location

  instance = {
    type                          = "linux"
    name                          = "app-demo-dev-xaesr"
    service_plan_id               = module.appservice.plans.web.id
    public_network_access_enabled = false

    site_config = {}
  }
}
