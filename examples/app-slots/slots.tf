locals {
  slots = {
    dev = {
      name = "development"
      identity = {
        type = "SystemAssigned"
      }
      site_config = {
        always_on                        = false
        http2_enabled                    = true
        app_command_line                 = ""
        pre_warmed_instance_count        = 1
        runtime_scale_monitoring_enabled = false
        scm_use_main_ip_restriction      = false
        minimum_tls_version              = "1.2"
        remote_debugging_enabled         = true
        use_32_bit_worker                = true
        websockets_enabled               = true
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
        cors = {
          allowed_origins = ["https://localhost:3000"]
        }
        ip_restrictions = {
          allow_dev_team = {
            name        = "Allow Dev Team"
            action      = "Allow"
            ip_address  = "10.0.1.0/24"
            priority    = 100
            description = "Allow development team IPs"
          }
          allow_localhost = {
            name        = "Allow Localhost Testing"
            action      = "Allow"
            ip_address  = "127.0.0.1/32"
            priority    = 200
            description = "Allow localhost for testing"
            headers = {
              x_forwarded_host = ["localhost", "dev.local"]
            }
          }
        }
        scm_ip_restrictions = {
          allow_dev_scm = {
            name        = "Allow Dev SCM Access"
            action      = "Allow"
            ip_address  = "10.0.1.0/24"
            priority    = 100
            description = "Allow dev team SCM access"
          }
        }
      }
    }
    staging = {
      name = "staging"
      identity = {
        type = "SystemAssigned"
      }
      site_config = {
        always_on                        = false
        http2_enabled                    = true
        app_command_line                 = ""
        pre_warmed_instance_count        = 2
        runtime_scale_monitoring_enabled = true
        scm_use_main_ip_restriction      = true
        minimum_tls_version              = "1.2"
        remote_debugging_enabled         = false
        use_32_bit_worker                = false
        websockets_enabled               = true
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
        cors = {
          allowed_origins = ["https://staging.example.com"]
        }
        ip_restrictions = {
          allow_staging_office = {
            name        = "Allow Staging Office"
            action      = "Allow"
            ip_address  = "203.0.113.128/25"
            priority    = 100
            description = "Allow staging office network"
          }
          allow_frontdoor_staging = {
            name        = "Allow Front Door Staging"
            action      = "Allow"
            service_tag = "AzureFrontDoor.Backend"
            priority    = 200
            description = "Allow Azure Front Door for staging"
            headers = { // test this
              x_azure_fdid      = ["11111111-1111-1111-1111-111111111111"]
              x_fd_health_probe = ["1"]
              x_forwarded_for   = ["10.0.0.0/8", "172.16.0.0/12"]
              x_forwarded_host  = ["staging.example.com"]
            }
          }
        }
        scm_ip_restrictions = {
          allow_staging_cicd = {
            name        = "Allow Staging CI/CD"
            action      = "Allow"
            service_tag = "AzureDevOps"
            priority    = 100
            description = "Allow Azure DevOps for staging deployments"
          }
          allow_staging_admins = {
            name        = "Allow Staging Admins"
            action      = "Allow"
            ip_address  = "198.51.100.128/25"
            priority    = 200
            description = "Allow admin access to staging SCM"
            headers = {
              x_forwarded_for = ["198.51.100.0/24"]
            }
          }
        }
      }
    }
  }
}
