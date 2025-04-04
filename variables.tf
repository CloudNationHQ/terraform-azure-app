variable "instance" {
  description = "Contains all web app configuration"
  type = object({
    name                                           = string
    type                                           = string
    resource_group                                 = optional(string, null)
    location                                       = optional(string, null)
    service_plan_id                                = string
    app_settings                                   = optional(map(string), {})
    client_affinity_enabled                        = optional(bool, null)
    client_certificate_enabled                     = optional(bool, null)
    client_certificate_mode                        = optional(string, "Required")
    client_certificate_exclusion_paths             = optional(string, null)
    enabled                                        = optional(bool, true)
    ftp_publish_basic_authentication_enabled       = optional(bool, true)
    https_only                                     = optional(bool, false)
    public_network_access_enabled                  = optional(bool, true)
    key_vault_reference_identity_id                = optional(string, null)
    virtual_network_subnet_id                      = optional(string, null)
    webdeploy_publish_basic_authentication_enabled = optional(bool, true)
    zip_deploy_file                                = optional(string, null)
    tags                                           = optional(map(string))
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string), null)
    }), null)
    site_config = object({
      always_on                                     = optional(bool, true)
      api_definition_url                            = optional(string, null)
      api_management_api_id                         = optional(string, null)
      app_command_line                              = optional(string, null)
      container_registry_managed_identity_client_id = optional(string, null)
      container_registry_use_managed_identity       = optional(bool, null)
      default_documents                             = optional(list(string), null)
      ftps_state                                    = optional(string, "Disabled")
      health_check_path                             = optional(string, null)
      health_check_eviction_time_in_min             = optional(number, null)
      http2_enabled                                 = optional(bool, null)
      ip_restriction_default_action                 = optional(string, "Allow")
      load_balancing_mode                           = optional(string, null)
      local_mysql_enabled                           = optional(bool, false)
      managed_pipeline_mode                         = optional(string, "Integrated")
      minimum_tls_version                           = optional(string, "1.2")
      remote_debugging_enabled                      = optional(bool, false)
      scm_ip_restriction_default_action             = optional(string, "Allow")
      scm_use_main_ip_restriction                   = optional(bool, null)
      use_32_bit_worker                             = optional(bool, true)
      vnet_route_all_enabled                        = optional(bool, false)
      websockets_enabled                            = optional(bool, false)
      worker_count                                  = optional(number, null)
      application_stack = optional(object({
        docker_image_name            = optional(string, null)
        docker_registry_url          = optional(string, null)
        docker_registry_username     = optional(string, null)
        docker_registry_password     = optional(string, null)
        dotnet_version               = optional(string, null)
        go_version                   = optional(string, null)
        java_server                  = optional(string, null)
        java_server_version          = optional(string, null)
        java_version                 = optional(string, null)
        node_version                 = optional(string, null)
        php_version                  = optional(string, null)
        python_version               = optional(string, null)
        ruby_version                 = optional(string, null)
        current_stack                = optional(string, null)
        dotnet_core_version          = optional(string, null)
        tomcat_version               = optional(string, null)
        java_embedded_server_enabled = optional(bool, null)
        python                       = optional(bool, false)
      }), null)
      auto_heal_setting = optional(object({
        action = object({
          action_type                    = string
          minimum_process_execution_time = optional(string, null)
        })
        trigger = object({
          requests = optional(object({
            count    = number
            interval = string
          }), null)
          slow_request = optional(object({
            count      = number
            interval   = string
            time_taken = string
          }), null)
          slow_request_with_path = optional(object({
            count      = number
            interval   = string
            time_taken = string
            path       = optional(string, null)
          }), null)
          status_code = optional(object({
            count             = number
            interval          = string
            status_code_range = string
            path              = optional(string, null)
            sub_status        = optional(string, null)
            win32_status_code = optional(string, null)
          }), null)
        })
      }), null)
      cors = optional(object({
        allowed_origins     = optional(list(string), null)
        support_credentials = optional(bool, false)
      }), null)
      ip_restrictions = optional(map(object({
        name                      = optional(string, null)
        action                    = optional(string, "Allow")
        ip_address                = optional(string, null)
        priority                  = optional(number, 65000)
        service_tag               = optional(string, null)
        virtual_network_subnet_id = optional(string, null)
        description               = optional(string, null)
        headers = optional(object({
          x_azure_fdid      = optional(list(string), [])
          x_fd_health_probe = optional(list(string), [])
          x_forwarded_for   = optional(list(string), [])
          x_forwarded_host  = optional(list(string), [])
        }), null)
      })), {})
      scm_ip_restrictions = optional(map(object({
        name                      = optional(string, null)
        action                    = optional(string, "Allow")
        ip_address                = optional(string, null)
        priority                  = optional(number, 65000)
        service_tag               = optional(string, null)
        virtual_network_subnet_id = optional(string, null)
        description               = optional(string, null)
        headers = optional(object({
          x_azure_fdid      = optional(list(string), [])
          x_fd_health_probe = optional(string, null)
          x_forwarded_for   = optional(list(string), [])
          x_forwarded_host  = optional(list(string), [])
        }), null)
      })), {})
    })
    auth_settings = optional(object({
      enabled                        = bool
      additional_login_parameters    = optional(map(string), null)
      allowed_external_redirect_urls = optional(list(string), null)
      default_provider               = optional(string, null)
      issuer                         = optional(string, null)
      runtime_version                = optional(string, null)
      token_refresh_extension_hours  = optional(number, 72)
      token_store_enabled            = optional(bool, false)
      unauthenticated_client_action  = optional(string, null)
      active_directory = optional(object({
        client_id                  = string
        allowed_audiences          = list(string)
        client_secret              = optional(string, null)
        client_secret_setting_name = optional(string, null)
      }), null)
      facebook = optional(object({
        app_id                  = string
        app_secret              = optional(string, null)
        app_secret_setting_name = optional(string, null)
        oauth_scopes            = optional(list(string), null)
      }), null)
      github = optional(object({
        client_id                  = string
        client_secret              = optional(string, null)
        client_secret_setting_name = optional(string, null)
        oauth_scopes               = optional(list(string), null)
      }), null)
      google = optional(object({
        client_id                  = string
        client_secret              = optional(string, null)
        client_secret_setting_name = optional(string, null)
        oauth_scopes               = optional(list(string), null)
      }), null)
      microsoft = optional(object({
        client_id                  = string
        client_secret              = optional(string, null)
        client_secret_setting_name = optional(string, null)
        oauth_scopes               = optional(list(string), null)
      }), null)
      twitter = optional(object({
        consumer_key                 = string
        consumer_secret              = optional(string, null)
        consumer_secret_setting_name = optional(string, null)
      }), null)
    }), null)
    auth_settings_v2 = optional(object({
      auth_enabled                            = optional(bool, null)
      runtime_version                         = optional(string, "~1")
      config_file_path                        = optional(string, null)
      require_authentication                  = optional(bool, null)
      unauthenticated_action                  = optional(string, null)
      default_provider                        = optional(string, null)
      excluded_paths                          = optional(list(string), null)
      require_https                           = optional(bool, true)
      http_route_api_prefix                   = optional(string, "/.auth")
      forward_proxy_convention                = optional(string, "NoProxy")
      forward_proxy_custom_host_header_name   = optional(string, null)
      forward_proxy_custom_scheme_header_name = optional(string, null)
      login = optional(object({
        logout_endpoint                   = optional(string, null)
        token_store_enabled               = optional(bool, false)
        token_refresh_extension_time      = optional(number, 72)
        token_store_path                  = optional(string, null)
        token_store_sas_setting_name      = optional(string, null)
        preserve_url_fragments_for_logins = optional(bool, false)
        allowed_external_redirect_urls    = optional(list(string), [])
        cookie_expiration_convention      = optional(string, "FixedTime")
        cookie_expiration_time            = optional(string, "08:00:00")
        validate_nonce                    = optional(bool, true)
        nonce_expiration_time             = optional(string, "00:05:00")
      }), null)
      apple_v2 = optional(object({
        client_id                  = string
        client_secret_setting_name = string
        login_scopes               = optional(list(string), null)
      }), null)
      active_directory_v2 = optional(object({
        client_id                            = string
        tenant_auth_endpoint                 = string
        client_secret_setting_name           = optional(string, null)
        client_secret_certificate_thumbprint = optional(string, null)
        jwt_allowed_groups                   = optional(list(string), [])
        jwt_allowed_client_applications      = optional(list(string), [])
        www_authentication_disabled          = optional(bool, false)
        allowed_applications                 = optional(list(string), [])
        allowed_audiences                    = optional(list(string), [])
        allowed_groups                       = optional(list(string), [])
        allowed_identities                   = optional(list(string), [])
      }), null)
      azure_static_web_app_v2 = optional(object({
        client_id = string
      }), null)
      custom_oidc_v2 = optional(map(object({
        name                          = string
        client_id                     = string
        openid_configuration_endpoint = string
        name_claim_type               = optional(string, null)
        scopes                        = optional(list(string), [])
        client_credential_method      = optional(string, null)
        client_secret_setting_name    = optional(string, null)
        authorisation_endpoint        = optional(string, null)
        token_endpoint                = optional(string, null)
        issuer_endpoint               = optional(string, null)
        certification_uri             = optional(string, null)
      })), {})
      facebook_v2 = optional(object({
        app_id                  = string
        app_secret_setting_name = string
        graph_api_version       = optional(string, null)
        login_scopes            = optional(list(string), [])
      }), null)
      github_v2 = optional(object({
        client_id                  = string
        client_secret_setting_name = string
        login_scopes               = optional(list(string), [])
      }), null)
      google_v2 = optional(object({
        client_id                  = string
        client_secret_setting_name = string
        allowed_audiences          = optional(list(string), [])
        login_scopes               = optional(list(string), [])
      }), null)
      microsoft_v2 = optional(object({
        client_id                  = string
        client_secret_setting_name = string
        allowed_audiences          = optional(list(string), [])
        login_scopes               = optional(list(string), [])
      }), null)
      twitter_v2 = optional(object({
        consumer_key                 = string
        consumer_secret_setting_name = string
      }), null)
    }), null)
    backup = optional(object({
      enabled             = optional(bool, true)
      name                = string
      storage_account_url = string
      schedule = object({
        frequency_interval       = number
        frequency_unit           = string
        keep_at_least_one_backup = optional(bool, false)
        retention_period_days    = optional(number, 30)
        start_time               = optional(string, null)
      })
    }), null)
    connection_string = optional(object({
      name  = string
      type  = string
      value = string
    }), null)
    logs = optional(object({
      detailed_error_messages = optional(bool, null)
      failed_request_tracing  = optional(bool, null)
      application_logs = optional(object({
        file_system_level = string
        azure_blob_storage = optional(object({
          level             = string
          sas_url           = string
          retention_in_days = optional(number, 0)
        }), null)
      }), null)
      http_logs = optional(object({
        azure_blob_storage = optional(object({
          sas_url           = string
          retention_in_days = optional(number, 0)
        }), null)
        file_system = optional(object({
          retention_in_days = optional(number, 0)
          retention_in_mb   = number
        }), null)
      }), null)
    }), null)
    storage_account = optional(object({
      access_key   = string
      account_name = string
      name         = string
      share_name   = string
      type         = string
      mount_path   = optional(string, null)
    }), null)
    sticky_settings = optional(object({
      app_setting_names       = optional(list(string), [])
      connection_string_names = optional(list(string), [])
    }), null)
    slots = optional(map(object({
      name                                           = optional(string, null)
      app_settings                                   = optional(map(string), {})
      client_affinity_enabled                        = optional(bool, null)
      client_certificate_enabled                     = optional(bool, null)
      client_certificate_mode                        = optional(string, "Required")
      client_certificate_exclusion_paths             = optional(string, null)
      enabled                                        = optional(bool, true)
      ftp_publish_basic_authentication_enabled       = optional(bool, true)
      https_only                                     = optional(bool, false)
      public_network_access_enabled                  = optional(bool, true)
      key_vault_reference_identity_id                = optional(string, null)
      virtual_network_subnet_id                      = optional(string, null)
      webdeploy_publish_basic_authentication_enabled = optional(bool, true)
      zip_deploy_file                                = optional(string, null)
      tags                                           = optional(map(string))
      identity = optional(object({
        type         = string
        identity_ids = optional(list(string), null)
      }), null)
      site_config = object({
        always_on                                     = optional(bool, true)
        api_definition_url                            = optional(string, null)
        api_management_api_id                         = optional(string, null)
        app_command_line                              = optional(string, null)
        container_registry_managed_identity_client_id = optional(string, null)
        container_registry_use_managed_identity       = optional(bool, null)
        default_documents                             = optional(list(string), null)
        ftps_state                                    = optional(string, "Disabled")
        health_check_path                             = optional(string, null)
        health_check_eviction_time_in_min             = optional(number, null)
        http2_enabled                                 = optional(bool, null)
        ip_restriction_default_action                 = optional(string, "Allow")
        load_balancing_mode                           = optional(string, null)
        local_mysql_enabled                           = optional(bool, false)
        managed_pipeline_mode                         = optional(string, "Integrated")
        minimum_tls_version                           = optional(string, "1.2")
        remote_debugging_enabled                      = optional(bool, false)
        scm_ip_restriction_default_action             = optional(string, "Allow")
        scm_use_main_ip_restriction                   = optional(bool, null)
        use_32_bit_worker                             = optional(bool, true)
        vnet_route_all_enabled                        = optional(bool, false)
        websockets_enabled                            = optional(bool, false)
        worker_count                                  = optional(number, null)
        application_stack = optional(object({
          docker_image_name            = optional(string, null)
          docker_registry_url          = optional(string, null)
          docker_registry_username     = optional(string, null)
          docker_registry_password     = optional(string, null)
          dotnet_version               = optional(string, null)
          go_version                   = optional(string, null)
          java_server                  = optional(string, null)
          java_server_version          = optional(string, null)
          java_version                 = optional(string, null)
          node_version                 = optional(string, null)
          php_version                  = optional(string, null)
          python_version               = optional(string, null)
          ruby_version                 = optional(string, null)
          current_stack                = optional(string, null)
          dotnet_core_version          = optional(string, null)
          tomcat_version               = optional(string, null)
          java_embedded_server_enabled = optional(bool, null)
          python                       = optional(bool, false)
        }), null)
        auto_heal_setting = optional(object({
          action = object({
            action_type                    = string
            minimum_process_execution_time = optional(string, null)
          })
          trigger = object({
            requests = optional(object({
              count    = number
              interval = string
            }), null)
            slow_request = optional(object({
              count      = number
              interval   = string
              time_taken = string
            }), null)
            slow_request_with_path = optional(object({
              count      = number
              interval   = string
              time_taken = string
              path       = optional(string, null)
            }), null)
            status_code = optional(object({
              count             = number
              interval          = string
              status_code_range = string
              path              = optional(string, null)
              sub_status        = optional(string, null)
              win32_status_code = optional(string, null)
            }), null)
          })
        }), null)
        cors = optional(object({
          allowed_origins     = optional(list(string), null)
          support_credentials = optional(bool, false)
        }), null)
        ip_restrictions = optional(map(object({
          name                      = optional(string, null)
          action                    = optional(string, "Allow")
          ip_address                = optional(string, null)
          priority                  = optional(number, 65000)
          service_tag               = optional(string, null)
          virtual_network_subnet_id = optional(string, null)
          description               = optional(string, null)
          headers = optional(object({
            x_azure_fdid      = optional(list(string), [])
            x_fd_health_probe = optional(string, null)
            x_forwarded_for   = optional(list(string), [])
            x_forwarded_host  = optional(list(string), [])
          }), null)
        })), {})
        scm_ip_restrictions = optional(map(object({
          name                      = optional(string, null)
          action                    = optional(string, "Allow")
          ip_address                = optional(string, null)
          priority                  = optional(number, 65000)
          service_tag               = optional(string, null)
          virtual_network_subnet_id = optional(string, null)
          description               = optional(string, null)
          headers = optional(object({
            x_azure_fdid      = optional(list(string), [])
            x_fd_health_probe = optional(string, null)
            x_forwarded_for   = optional(list(string), [])
            x_forwarded_host  = optional(list(string), [])
          }), null)
        })), {})
      })
    })), {})
  })

  validation {
    condition     = contains(["windows", "linux"], var.instance.type)
    error_message = "The instance type must be either 'windows' or 'linux'."
  }

  validation {
    condition     = var.instance.location != null || var.location != null
    error_message = "Location must be provided either in the instance object or as a separate variable."
  }

  validation {
    condition     = var.instance.resource_group != null || var.resource_group != null
    error_message = "Resource group name must be provided either in the instance object or as a separate variable."
  }
}

variable "location" {
  description = "default azure region to be used"
  type        = string
  default     = null
}

variable "resource_group" {
  description = "default resource group to be used"
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
