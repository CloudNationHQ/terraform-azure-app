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
  version = "~> 3.0"

  resource_group = module.rg.groups.demo.name
  location       = module.rg.groups.demo.location

  instance = {
    type            = "linux"
    name            = "app-demo-dev-xaesq"
    service_plan_id = module.appservice.plans.web.id
    slots           = local.slots

    site_config = {
      auto_heal_enabled = true
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
    }
  }
}
