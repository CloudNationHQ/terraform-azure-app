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

module "appservice" {
  source  = "cloudnationhq/plan/azure"
  version = "~> 1.0"

  resource_group = module.rg.groups.demo.name
  location       = module.rg.groups.demo.location

  plans = {
    web = {
      name     = module.naming.app_service_plan.name
      os_type  = "Windows"
      sku_name = "P1v2"
    }
  }
}

module "webapp" {
  source  = "cloudnationhq/web/azure"
  version = "~> 1.0"

  resource_group = module.rg.groups.demo.name
  location       = module.rg.groups.demo.location

  instance = {
    type            = "windows"
    name            = "app-demo-dev-xaeso"
    service_plan_id = module.appservice.plans.web.id
    site_config = {
      http2_enabled = true
      application_stack = {
        dotnet_version = "v6.0"
      }
    }
  }
}
