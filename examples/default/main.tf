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
    type            = "linux"
    name            = "app-demo-dev-xaese"
    service_plan_id = module.appservice.plans.web.id
    site_config     = {}
  }
}
