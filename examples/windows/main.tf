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

module "appservice" {
  source  = "cloudnationhq/plan/azure"
  version = "~> 3.0"

  resource_group_name = module.rg.groups.demo.name
  location            = module.rg.groups.demo.location

  plans = {
    web = {
      name     = module.naming.app_service_plan.name
      os_type  = "Windows"
      sku_name = "P1v2"
    }
  }
}

module "webapp" {
  source  = "cloudnationhq/app/azure"
  version = "~> 5.0"

  resource_group_name = module.rg.groups.demo.name
  location            = module.rg.groups.demo.location

  instance = {
    type            = "windows"
    name            = "app-demo-dev-xaesy"
    service_plan_id = module.appservice.plans.web.id
    site_config = {
      http2_enabled     = true
      application_stack = {}
      handler_mappings = {
        php = {
          extension             = "*.php"
          script_processor_path = "D:\\home\\site\\wwwroot\\handler.php"
          arguments             = "-d display_errors=On"
        }
        aspnet = {
          extension             = "*.aspx"
          script_processor_path = "D:\\Windows\\Microsoft.NET\\Framework64\\v4.0.30319\\aspnet_isapi.dll"
          arguments             = "/LM/W3SVC/1/ROOT"
        }
      }
      virtual_applications = {
        root = {
          virtual_path  = "/"
          physical_path = "site\\wwwroot"
          preload       = true
          virtual_directories = {
            images = {
              virtual_path  = "/images"
              physical_path = "site\\wwwroot\\images"
            }
            static = {
              virtual_path  = "/static"
              physical_path = "site\\wwwroot\\static"
            }
          }
        }
        api = {
          virtual_path        = "/api"
          physical_path       = "site\\wwwroot\\api"
          preload             = false
          virtual_directories = {}
        }
      }
      ip_restrictions = {
        allow_office = {
          name        = "Allow Office Network"
          action      = "Allow"
          ip_address  = "203.0.113.0/24"
          priority    = 100
          description = "Allow office IP range"
        }
        allow_azure_frontdoor = {
          name        = "Allow Azure Front Door"
          action      = "Allow"
          service_tag = "AzureFrontDoor.Backend"
          priority    = 200
          description = "Allow Azure Front Door traffic"
          headers = {
            x_azure_fdid     = ["00000000-0000-0000-0000-000000000000"]
            x_forwarded_for  = ["10.0.0.0/8"]
            x_forwarded_host = ["example.com", "www.example.com"]
          }
        }
      }
      scm_ip_restrictions = {
        allow_devops = {
          name        = "Allow DevOps Agents"
          action      = "Allow"
          ip_address  = "198.51.100.0/24"
          priority    = 100
          description = "Allow DevOps agent IP range"
        }
        allow_vpn = {
          name        = "Allow VPN Network"
          action      = "Allow"
          ip_address  = "192.0.2.0/24"
          priority    = 200
          description = "Allow VPN access to SCM"
          headers = {
            x_forwarded_for = ["192.0.2.0/24"]
          }
        }
      }
    }
  }
}
