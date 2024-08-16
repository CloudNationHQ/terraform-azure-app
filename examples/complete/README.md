This example highlights the complete usage.

## Remark

This example uses a data block to grab the public IP that is used run the terraform apply. This is needed for the accessing the webapp once deployed. Do not use this in a customer environment, it is solely to provide a working example.

## Usage

```hcl
module "webapp" {
  source = "../../"

  resource_group = module.rg.groups.demo.name
  location       = module.rg.groups.demo.location

  instance = {
    type                          = "linux"
    name                          = "web-app-complete-module-demo"
    service_plan_id               = module.serviceplan.plans.plan1.id
    virtual_network_subnet_id     = module.network.subnets.sn1.id
    public_network_access_enabled = true

    site_config                   = local.site_config
    slots                         = local.slots

    identity = {
      type = "UserAssigned"
    }
  }
}
```