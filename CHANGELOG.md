# Changelog

## [4.0.0](https://github.com/CloudNationHQ/terraform-azure-app/compare/v3.1.1...v4.0.0) (2025-05-07)


### ⚠ BREAKING CHANGES

* The data structure changed, causing a recreate on existing resources.

### Features

* small refactor ([#39](https://github.com/CloudNationHQ/terraform-azure-app/issues/39)) ([ac7afcf](https://github.com/CloudNationHQ/terraform-azure-app/commit/ac7afcf18eb768449073734907565929b35148ad))

### Upgrade from v3.1.1 to v4.0.0:

- Update module reference to: `version = "~> 4.0"`
- The property and variable resource_group is renamed to resource_group_name

## [3.1.1](https://github.com/CloudNationHQ/terraform-azure-app/compare/v3.1.0...v3.1.1) (2025-04-14)


### Bug Fixes

* fix submodule generation from makefile ([#36](https://github.com/CloudNationHQ/terraform-azure-app/issues/36)) ([1ca3728](https://github.com/CloudNationHQ/terraform-azure-app/commit/1ca3728c402885240699ef7580393430264bdea8))

## [3.1.0](https://github.com/CloudNationHQ/terraform-azure-app/compare/v3.0.0...v3.1.0) (2025-04-07)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#29](https://github.com/CloudNationHQ/terraform-azure-app/issues/29)) ([e97659d](https://github.com/CloudNationHQ/terraform-azure-app/commit/e97659de9f395b5119e73c5e1dab7155ceadc48e))
* **deps:** bump golang.org/x/net from 0.33.0 to 0.36.0 in /tests ([#30](https://github.com/CloudNationHQ/terraform-azure-app/issues/30)) ([7f56579](https://github.com/CloudNationHQ/terraform-azure-app/commit/7f56579e4a68e49b0e163fd231152c2568c045d7))


### Bug Fixes

* slot references and type definitions and added additional properties ([#34](https://github.com/CloudNationHQ/terraform-azure-app/issues/34)) ([ca83a90](https://github.com/CloudNationHQ/terraform-azure-app/commit/ca83a90a2022f027cd0f226a5d6036feb1f8de18))

## [3.0.0](https://github.com/CloudNationHQ/terraform-azure-app/compare/v2.4.0...v3.0.0) (2025-04-04)


### ⚠ BREAKING CHANGES

* removed system assigned identity default

### Features

* add type definitions and made identity fully optional ([#31](https://github.com/CloudNationHQ/terraform-azure-app/issues/31)) ([c13fdb6](https://github.com/CloudNationHQ/terraform-azure-app/commit/c13fdb6cba5d73146bcb899d535477552349f18e))

### Upgrade from v2.4.0 to v3.0.0:

- Update module reference to: `version = "~> 3.0"`
- The user assigned identity is removed from the module and it is not set to system assigned default anymore as well.
  - For identity we created a separate module as shown in the examples.

## [2.4.0](https://github.com/CloudNationHQ/terraform-azure-app/compare/v2.3.0...v2.4.0) (2025-01-20)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#24](https://github.com/CloudNationHQ/terraform-azure-app/issues/24)) ([39fb401](https://github.com/CloudNationHQ/terraform-azure-app/commit/39fb401b26d9ed3717ee62c9b005fb12ed2758b1))
* **deps:** bump golang.org/x/crypto from 0.21.0 to 0.31.0 in /tests ([#22](https://github.com/CloudNationHQ/terraform-azure-app/issues/22)) ([86717f4](https://github.com/CloudNationHQ/terraform-azure-app/commit/86717f4917879e249a5cea909a95a455a79070f2))
* **deps:** bump golang.org/x/net from 0.23.0 to 0.33.0 in /tests ([#27](https://github.com/CloudNationHQ/terraform-azure-app/issues/27)) ([1263108](https://github.com/CloudNationHQ/terraform-azure-app/commit/1263108170c32073f5e3c7a8378c71a1aa543097))
* remove temporary files when deployment tests fails ([#25](https://github.com/CloudNationHQ/terraform-azure-app/issues/25)) ([f997d04](https://github.com/CloudNationHQ/terraform-azure-app/commit/f997d0446b42752c964033e10754ca73b93f3ee9))

## [2.3.0](https://github.com/CloudNationHQ/terraform-azure-app/compare/v2.2.0...v2.3.0) (2024-11-11)


### Features

* enhance testing with sequential, parallel modes and flags for exceptions and skip-destroy ([#20](https://github.com/CloudNationHQ/terraform-azure-app/issues/20)) ([c4c8ea5](https://github.com/CloudNationHQ/terraform-azure-app/commit/c4c8ea560d0341c0472bac7e98eb583ebaad2fdf))

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
