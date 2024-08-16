This example illustrates the default setup, in its simplest form.

## Usage: default

```hcl
module "webapp" {
  source  = "cloudnationhq/web/azure"
  version = "~> 0.1"

  resource_group = module.rg.groups.demo.name
  location       = module.rg.groups.demo.location

  instance = {
    type                       = "linux"
    name                       = "web-app-default-module-demo"
    service_plan_id            = module.serviceplan.plans.plan1.id

    site_config = {}
  }
}
```