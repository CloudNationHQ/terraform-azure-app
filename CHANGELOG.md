# Changelog

## [2.2.0](https://github.com/CloudNationHQ/terraform-azure-app/compare/v2.1.0...v2.2.0) (2024-10-23)


### Features

* add the ability to pass app settings to the app service ([#18](https://github.com/CloudNationHQ/terraform-azure-app/issues/18)) ([0f7e9b7](https://github.com/CloudNationHQ/terraform-azure-app/commit/0f7e9b781c3a4e06073d270060d04c6bf25ae94d))

## [2.1.0](https://github.com/CloudNationHQ/terraform-azure-app/compare/v2.0.0...v2.1.0) (2024-10-11)


### Features

* auto generated docs and refine makefile ([#15](https://github.com/CloudNationHQ/terraform-azure-app/issues/15)) ([89acc4f](https://github.com/CloudNationHQ/terraform-azure-app/commit/89acc4f8e4834c2a503d781ca266419ab775f729))

## [2.0.0](https://github.com/CloudNationHQ/terraform-azure-app/compare/v1.2.0...v2.0.0) (2024-10-07)


### ⚠ BREAKING CHANGES

* Version 4 of the azurerm provider includes breaking changes.

### Features

* upgrade azurerm provider to v4 ([#13](https://github.com/CloudNationHQ/terraform-azure-app/issues/13)) ([3a614c2](https://github.com/CloudNationHQ/terraform-azure-app/commit/3a614c2866e9c79cec4cbd3d59fa489b0fdae8e4))

### Upgrade from v1.2.0 to v2.0.0:

- Update module reference to: `version = "~> 2.0"`
- Deprecated properties in instance object:
  - auto_heal_enabled -> deprecated
  - docker_container_name -> deprecated
  - docker_container_tag -> deprecated

## [1.2.0](https://github.com/CloudNationHQ/terraform-azure-app/compare/v1.1.1...v1.2.0) (2024-10-07)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#10](https://github.com/CloudNationHQ/terraform-azure-app/issues/10)) ([74f50de](https://github.com/CloudNationHQ/terraform-azure-app/commit/74f50dee485ecb7908119fee9fc4a3345df48a75))


### Bug Fixes

* sanitize go testing ([#8](https://github.com/CloudNationHQ/terraform-azure-app/issues/8)) ([f508150](https://github.com/CloudNationHQ/terraform-azure-app/commit/f508150220264f323bffcb43d1f00c4a9a51741a))

## [1.1.1](https://github.com/CloudNationHQ/terraform-azure-app/compare/v1.1.0...v1.1.1) (2024-08-16)


### Bug Fixes

* fix module references ([#4](https://github.com/CloudNationHQ/terraform-azure-app/issues/4)) ([693e299](https://github.com/CloudNationHQ/terraform-azure-app/commit/693e299d519b3599f5170fcf9e25db5c7c0ba25f))

## [1.1.0](https://github.com/CloudNationHQ/terraform-azure-app/compare/v1.0.0...v1.1.0) (2024-08-16)


### Features

* added code of conduct and security documentation ([33dbbfe](https://github.com/CloudNationHQ/terraform-azure-app/commit/33dbbfee133c6e255e090eab8658362fe6ec2b4e))
* fix linting issues ([48def4f](https://github.com/CloudNationHQ/terraform-azure-app/commit/48def4fbf235c54f3d356b92b6d1084ac99ac6a2))
* increment module versions ([f23dfdf](https://github.com/CloudNationHQ/terraform-azure-app/commit/f23dfdfd16fc3f031c1bd14b1c29cd05a5880233))

## 1.0.0 (2024-08-16)


### Features

* add initial resources ([235eed3](https://github.com/CloudNationHQ/terraform-azure-app/commit/235eed3e072b3fb10c253f322f31b5394dedf8b8))
