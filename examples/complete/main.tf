module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name
      location = "westeurope"
    }
  }
}

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 4.0"

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
      sn2 = {
        nsg  = {}
        cidr = ["10.18.2.0/24"]
      }
    }
  }
}

module "private_dns" {
  source  = "cloudnationhq/pdns/azure"
  version = "~> 2.0"

  resource_group = module.rg.groups.demo.name

  zones = {
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

module "privatelink" {
  source  = "cloudnationhq/pe/azure"
  version = "~> 1.0"

  resource_group = module.rg.groups.demo.name
  location       = module.rg.groups.demo.location

  endpoints = {
    webapp = {
      name                           = module.naming.private_endpoint.name
      subnet_id                      = module.network.subnets.sn2.id
      private_connection_resource_id = module.webapp.instance.id
      private_dns_zone_ids           = [module.private_dns.zones.web.id]
      subresource_names              = ["sites"]
    }
  }
}

module "serviceplan" {
  source  = "cloudnationhq/plan/azure"
  version = "~> 2.0"

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
  source  = "cloudnationhq/app/azure"
  version = "~> 2.0"

  resource_group = module.rg.groups.demo.name
  location       = module.rg.groups.demo.location

  instance = {
    type                          = "linux"
    name                          = "app-demo-dev-xaeso"
    service_plan_id               = module.serviceplan.plans.web.id
    virtual_network_subnet_id     = module.network.subnets.sn1.id
    public_network_access_enabled = false
    slots                         = local.slots

    site_config = {
      always_on                     = false
      auto_heal_enabled             = true
      http2_enabled                 = true
      load_balancing_mode           = "LeastRequests"
      minimum_tls_version           = "1.2"
      ip_restriction_default_action = "Deny"

      application_stack = {
        docker_image_name   = "node:latest"
        docker_registry_url = "https://index.docker.io"
      }

      auto_heal_setting = {
        action = {
          action_type                = "Recycle"
          min_process_execution_time = "00:00:30"
        }
        trigger = {
          requests = {
            count    = 3
            interval = "00:01:00"
          }
        }
      }

      ip_restrictions = {
        allow_internal = {
          action                    = "Allow"
          priority                  = 100
          name                      = "AllowInternal"
          virtual_network_subnet_id = module.network.subnets.sn2.id
        }
        allow_external = {
          action     = "Allow"
          priority   = 200
          name       = "AllowExternal"
          ip_address = "8.8.8.8/32"
          headers = {
            x_forwarded_host = ["google.com"]
          }
        }
      }
    }

    identity = {
      type = "UserAssigned"
    }
  }
}
