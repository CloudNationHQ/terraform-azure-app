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

module "storage1" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 4.0"

  storage = {
    name                = "${module.naming.storage_account.name_unique}1"
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
  }
}

module "storage2" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 4.0"

  storage = {
    name                = "${module.naming.storage_account.name_unique}2"
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
  }
}

module "webapp" {
  source  = "cloudnationhq/app/azure"
  version = "~> 5.0"

  resource_group_name = module.rg.groups.demo.name
  location            = module.rg.groups.demo.location

  instance = {
    type            = "linux"
    name            = "app-demo-dev-xaesq"
    service_plan_id = module.appservice.plans.web.id
    slots           = local.slots

    connection_strings = {
      storage1 = {
        name  = "storage_conn"
        type  = "Custom"
        value = module.storage1.account.primary_connection_string
      }
      storage2 = {
        name  = "storage1"
        type  = "Custom"
        value = module.storage2.account.primary_connection_string
      }
    }

    site_config = {
      auto_heal_setting = {
        action = {
          action_type = "Recycle"
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
