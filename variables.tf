variable "web_app" {
  description = "Contains all web app configuration"
  type = object({
    name                                           = string
    type                                           = string
    resource_group_name                            = optional(string)
    location                                       = optional(string)
    service_plan_id                                = string
    app_settings                                   = optional(map(string), {})
    client_affinity_enabled                        = optional(bool)
    client_certificate_enabled                     = optional(bool)
    client_certificate_mode                        = optional(string)
    client_certificate_exclusion_paths             = optional(string)
    enabled                                        = optional(bool)
    ftp_publish_basic_authentication_enabled       = optional(bool)
    https_only                                     = optional(bool)
    public_network_access_enabled                  = optional(bool)
    key_vault_reference_identity_id                = optional(string)
    virtual_network_subnet_id                      = optional(string)
    virtual_network_image_pull_enabled             = optional(bool)
    webdeploy_publish_basic_authentication_enabled = optional(bool)
    zip_deploy_file                                = optional(string)
    virtual_network_backup_restore_enabled         = optional(bool)
    tags                                           = optional(map(string))
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
    site_config = object({
      always_on                                     = optional(bool)
      api_definition_url                            = optional(string)
      api_management_api_id                         = optional(string)
      app_command_line                              = optional(string)
      container_registry_managed_identity_client_id = optional(string)
      container_registry_use_managed_identity       = optional(bool)
      default_documents                             = optional(list(string))
      ftps_state                                    = optional(string)
      health_check_path                             = optional(string)
      health_check_eviction_time_in_min             = optional(number)
      http2_enabled                                 = optional(bool)
      ip_restriction_default_action                 = optional(string)
      load_balancing_mode                           = optional(string)
      local_mysql_enabled                           = optional(bool)
      managed_pipeline_mode                         = optional(string)
      minimum_tls_version                           = optional(string)
      minimum_tls_cipher_suite                      = optional(string)
      remote_debugging_enabled                      = optional(bool)
      scm_ip_restriction_default_action             = optional(string)
      scm_use_main_ip_restriction                   = optional(bool)
      use_32_bit_worker                             = optional(bool)
      vnet_route_all_enabled                        = optional(bool)
      websockets_enabled                            = optional(bool)
      worker_count                                  = optional(number)
      scm_minimum_tls_version                       = optional(string)
      remote_debugging_version                      = optional(string)
      application_stack = optional(object({
        docker_image_name            = optional(string)
        docker_registry_url          = optional(string)
        docker_registry_username     = optional(string)
        docker_registry_password     = optional(string)
        dotnet_version               = optional(string)
        go_version                   = optional(string)
        java_server                  = optional(string)
        java_server_version          = optional(string)
        java_version                 = optional(string)
        node_version                 = optional(string)
        php_version                  = optional(string)
        python_version               = optional(string)
        current_stack                = optional(string)
        dotnet_core_version          = optional(string)
        tomcat_version               = optional(string)
        java_embedded_server_enabled = optional(bool)
        python                       = optional(bool)
      }))
      auto_heal_setting = optional(object({
        action = object({
          action_type                    = string
          minimum_process_execution_time = optional(string)
          custom_action = optional(object({
            executable = string
            parameters = optional(string)
          }))
        })
        trigger = object({
          private_memory_kb = optional(number)
          requests = optional(object({
            count    = number
            interval = string
          }))
          slow_request = optional(object({
            count      = number
            interval   = string
            time_taken = string
          }))
          slow_request_with_path = optional(map(object({
            count      = number
            interval   = string
            time_taken = string
            path       = optional(string)
          })), {})
          status_code = optional(map(object({
            count             = number
            interval          = string
            status_code_range = string
            path              = optional(string)
            sub_status        = optional(string)
            win32_status_code = optional(string)
          })), {})
        })
      }))
      cors = optional(object({
        allowed_origins     = optional(list(string))
        support_credentials = optional(bool)
      }))
      handler_mappings = optional(map(object({
        arguments             = optional(string)
        extension             = string
        script_processor_path = string
      })), {})
      virtual_applications = optional(map(object({
        virtual_path  = string
        physical_path = string
        preload       = optional(bool)
        virtual_directories = optional(map(object({
          virtual_path  = string
          physical_path = string
        })), {})
      })), {})
      ip_restrictions = optional(map(object({
        name                      = optional(string)
        action                    = optional(string)
        ip_address                = optional(string)
        priority                  = optional(number)
        service_tag               = optional(string)
        virtual_network_subnet_id = optional(string)
        description               = optional(string)
        headers = optional(object({
          x_azure_fdid      = optional(list(string), [])
          x_fd_health_probe = optional(list(string), [])
          x_forwarded_for   = optional(list(string), [])
          x_forwarded_host  = optional(list(string), [])
        }))
      })), {})
      scm_ip_restrictions = optional(map(object({
        name                      = optional(string)
        action                    = optional(string)
        ip_address                = optional(string)
        priority                  = optional(number)
        service_tag               = optional(string)
        virtual_network_subnet_id = optional(string)
        description               = optional(string)
        headers = optional(object({
          x_azure_fdid      = optional(list(string), [])
          x_fd_health_probe = optional(list(string), [])
          x_forwarded_for   = optional(list(string), [])
          x_forwarded_host  = optional(list(string), [])
        }))
      })), {})
    })
    auth_settings = optional(object({
      enabled                        = bool
      additional_login_parameters    = optional(map(string))
      allowed_external_redirect_urls = optional(list(string))
      default_provider               = optional(string)
      issuer                         = optional(string)
      runtime_version                = optional(string)
      token_refresh_extension_hours  = optional(number)
      token_store_enabled            = optional(bool)
      unauthenticated_client_action  = optional(string)
      active_directory = optional(object({
        client_id                  = string
        allowed_audiences          = list(string)
        client_secret              = optional(string)
        client_secret_setting_name = optional(string)
      }))
      facebook = optional(object({
        app_id                  = string
        app_secret              = optional(string)
        app_secret_setting_name = optional(string)
        oauth_scopes            = optional(list(string))
      }))
      github = optional(object({
        client_id                  = string
        client_secret              = optional(string)
        client_secret_setting_name = optional(string)
        oauth_scopes               = optional(list(string))
      }))
      google = optional(object({
        client_id                  = string
        client_secret              = optional(string)
        client_secret_setting_name = optional(string)
        oauth_scopes               = optional(list(string))
      }))
      microsoft = optional(object({
        client_id                  = string
        client_secret              = optional(string)
        client_secret_setting_name = optional(string)
        oauth_scopes               = optional(list(string))
      }))
      twitter = optional(object({
        consumer_key                 = string
        consumer_secret              = optional(string)
        consumer_secret_setting_name = optional(string)
      }))
    }))
    auth_settings_v2 = optional(object({
      auth_enabled                            = optional(bool)
      runtime_version                         = optional(string)
      config_file_path                        = optional(string)
      require_authentication                  = optional(bool)
      unauthenticated_action                  = optional(string)
      default_provider                        = optional(string)
      excluded_paths                          = optional(list(string))
      require_https                           = optional(bool)
      http_route_api_prefix                   = optional(string)
      forward_proxy_convention                = optional(string)
      forward_proxy_custom_host_header_name   = optional(string)
      forward_proxy_custom_scheme_header_name = optional(string)
      login = optional(object({
        logout_endpoint                   = optional(string)
        token_store_enabled               = optional(bool)
        token_refresh_extension_time      = optional(number)
        token_store_path                  = optional(string)
        token_store_sas_setting_name      = optional(string)
        preserve_url_fragments_for_logins = optional(bool)
        allowed_external_redirect_urls    = optional(list(string))
        cookie_expiration_convention      = optional(string)
        cookie_expiration_time            = optional(string)
        validate_nonce                    = optional(bool)
        nonce_expiration_time             = optional(string)
      }))
      apple_v2 = optional(object({
        client_id                  = string
        client_secret_setting_name = string
        login_scopes               = optional(list(string))
      }))
      active_directory_v2 = optional(object({
        client_id                            = string
        tenant_auth_endpoint                 = string
        client_secret_setting_name           = optional(string)
        client_secret_certificate_thumbprint = optional(string)
        jwt_allowed_groups                   = optional(list(string), [])
        jwt_allowed_client_applications      = optional(list(string), [])
        www_authentication_disabled          = optional(bool)
        allowed_applications                 = optional(list(string), [])
        allowed_audiences                    = optional(list(string), [])
        allowed_groups                       = optional(list(string), [])
        allowed_identities                   = optional(list(string), [])
        login_parameters                     = optional(map(string), {})
      }))
      azure_static_web_app_v2 = optional(object({
        client_id = string
      }))
      custom_oidc_v2 = optional(map(object({
        name                          = string
        client_id                     = string
        openid_configuration_endpoint = string
        name_claim_type               = optional(string)
        scopes                        = optional(list(string), [])
        client_credential_method      = optional(string)
        client_secret_setting_name    = optional(string)
        authorisation_endpoint        = optional(string)
        token_endpoint                = optional(string)
        issuer_endpoint               = optional(string)
        certification_uri             = optional(string)
      })))
      facebook_v2 = optional(object({
        app_id                  = string
        app_secret_setting_name = string
        graph_api_version       = optional(string)
        login_scopes            = optional(list(string), [])
      }))
      github_v2 = optional(object({
        client_id                  = string
        client_secret_setting_name = string
        login_scopes               = optional(list(string), [])
      }))
      google_v2 = optional(object({
        client_id                  = string
        client_secret_setting_name = string
        allowed_audiences          = optional(list(string), [])
        login_scopes               = optional(list(string), [])
      }))
      microsoft_v2 = optional(object({
        client_id                  = string
        client_secret_setting_name = string
        allowed_audiences          = optional(list(string), [])
        login_scopes               = optional(list(string), [])
      }))
      twitter_v2 = optional(object({
        consumer_key                 = string
        consumer_secret_setting_name = string
      }))
    }))
    backup = optional(object({
      enabled             = optional(bool)
      name                = string
      storage_account_url = string
      schedule = object({
        frequency_interval       = number
        frequency_unit           = string
        keep_at_least_one_backup = optional(bool)
        retention_period_days    = optional(number)
        start_time               = optional(string)
      })
    }))
    connection_strings = optional(
      map(object({
        name  = string
        type  = string
        value = string
    })), {})
    logs = optional(object({
      detailed_error_messages = optional(bool)
      failed_request_tracing  = optional(bool)
      application_logs = optional(object({
        file_system_level = string
        azure_blob_storage = optional(object({
          level             = string
          sas_url           = string
          retention_in_days = optional(number, 0)
        }))
      }))
      http_logs = optional(object({
        azure_blob_storage = optional(object({
          sas_url           = string
          retention_in_days = optional(number, 0)
        }))
        file_system = optional(object({
          retention_in_days = optional(number, 0)
          retention_in_mb   = number
        }))
      }))
    }))
    storage_accounts = optional(map(object({
      access_key   = string
      account_name = string
      name         = optional(string)
      share_name   = string
      type         = string
      mount_path   = optional(string)
    })), {})
    sticky_settings = optional(object({
      app_setting_names       = optional(list(string), [])
      connection_string_names = optional(list(string), [])
    }))
    slots = optional(map(object({
      name                                           = optional(string)
      app_settings                                   = optional(map(string), {})
      client_affinity_enabled                        = optional(bool)
      client_certificate_enabled                     = optional(bool)
      client_certificate_mode                        = optional(string)
      client_certificate_exclusion_paths             = optional(string)
      enabled                                        = optional(bool)
      ftp_publish_basic_authentication_enabled       = optional(bool)
      https_only                                     = optional(bool)
      public_network_access_enabled                  = optional(bool)
      key_vault_reference_identity_id                = optional(string)
      virtual_network_subnet_id                      = optional(string)
      virtual_network_image_pull_enabled             = optional(bool)
      webdeploy_publish_basic_authentication_enabled = optional(bool)
      zip_deploy_file                                = optional(string)
      virtual_network_backup_restore_enabled         = optional(bool)
      service_plan_id                                = optional(string)
      tags                                           = optional(map(string))
      identity = optional(object({
        type         = string
        identity_ids = optional(list(string))
      }))
      site_config = object({
        always_on                                     = optional(bool)
        api_definition_url                            = optional(string)
        api_management_api_id                         = optional(string)
        app_command_line                              = optional(string)
        container_registry_managed_identity_client_id = optional(string)
        container_registry_use_managed_identity       = optional(bool)
        default_documents                             = optional(list(string))
        ftps_state                                    = optional(string)
        health_check_path                             = optional(string)
        health_check_eviction_time_in_min             = optional(number)
        http2_enabled                                 = optional(bool)
        ip_restriction_default_action                 = optional(string)
        load_balancing_mode                           = optional(string)
        local_mysql_enabled                           = optional(bool)
        managed_pipeline_mode                         = optional(string)
        minimum_tls_version                           = optional(string)
        minimum_tls_cipher_suite                      = optional(string)
        remote_debugging_enabled                      = optional(bool)
        scm_ip_restriction_default_action             = optional(string)
        scm_use_main_ip_restriction                   = optional(bool)
        use_32_bit_worker                             = optional(bool)
        vnet_route_all_enabled                        = optional(bool)
        websockets_enabled                            = optional(bool)
        worker_count                                  = optional(number)
        remote_debugging_version                      = optional(string)
        scm_minimum_tls_version                       = optional(string)
        auto_swap_slot_name                           = optional(string)
        application_stack = optional(object({
          docker_image_name            = optional(string)
          docker_registry_url          = optional(string)
          docker_registry_username     = optional(string)
          docker_registry_password     = optional(string)
          dotnet_version               = optional(string)
          go_version                   = optional(string)
          java_server                  = optional(string)
          java_server_version          = optional(string)
          java_version                 = optional(string)
          node_version                 = optional(string)
          php_version                  = optional(string)
          python_version               = optional(string)
          ruby_version                 = optional(string)
          current_stack                = optional(string)
          dotnet_core_version          = optional(string)
          tomcat_version               = optional(string)
          java_embedded_server_enabled = optional(bool)
          python                       = optional(bool)
        }))
        auto_heal_setting = optional(object({
          action = object({
            action_type                    = string
            minimum_process_execution_time = optional(string)
            custom_action = optional(object({
              executable = string
              parameters = optional(string)
            }))
          })
          trigger = object({
            private_memory_kb = optional(number)
            requests = optional(object({
              count    = number
              interval = string
            }))
            slow_request = optional(object({
              count      = number
              interval   = string
              time_taken = string
            }))
            slow_request_with_path = optional(map(object({
              count      = number
              interval   = string
              time_taken = string
              path       = optional(string)
            })), {})
            status_code = optional(map(object({
              count             = number
              interval          = string
              status_code_range = string
              path              = optional(string)
              sub_status        = optional(string)
              win32_status_code = optional(string)
            })), {})
          })
        }))
        cors = optional(object({
          allowed_origins     = optional(list(string))
          support_credentials = optional(bool)
        }))
        handler_mappings = optional(map(object({
          arguments             = optional(string)
          extension             = string
          script_processor_path = string
        })), {})
        virtual_applications = optional(map(object({
          virtual_path  = string
          physical_path = string
          preload       = optional(bool)
          virtual_directories = optional(map(object({
            virtual_path  = string
            physical_path = string
          })), {})
        })), {})
        ip_restrictions = optional(map(object({
          name                      = optional(string)
          action                    = optional(string)
          ip_address                = optional(string)
          priority                  = optional(number)
          service_tag               = optional(string)
          virtual_network_subnet_id = optional(string)
          description               = optional(string)
          headers = optional(object({
            x_azure_fdid      = optional(list(string), [])
            x_fd_health_probe = optional(list(string), [])
            x_forwarded_for   = optional(list(string), [])
            x_forwarded_host  = optional(list(string), [])
          }))
        })), {})
        scm_ip_restrictions = optional(map(object({
          name                      = optional(string)
          action                    = optional(string)
          ip_address                = optional(string)
          priority                  = optional(number)
          service_tag               = optional(string)
          virtual_network_subnet_id = optional(string)
          description               = optional(string)
          headers = optional(object({
            x_azure_fdid      = optional(list(string), [])
            x_fd_health_probe = optional(list(string), [])
            x_forwarded_for   = optional(list(string), [])
            x_forwarded_host  = optional(list(string), [])
          }))
        })), {})
      })
      auth_settings = optional(object({
        enabled                        = bool
        additional_login_parameters    = optional(map(string))
        allowed_external_redirect_urls = optional(list(string))
        default_provider               = optional(string)
        issuer                         = optional(string)
        runtime_version                = optional(string)
        token_refresh_extension_hours  = optional(number)
        token_store_enabled            = optional(bool)
        unauthenticated_client_action  = optional(string)
        active_directory = optional(object({
          client_id                  = string
          allowed_audiences          = list(string)
          client_secret              = optional(string)
          client_secret_setting_name = optional(string)
        }))
        facebook = optional(object({
          app_id                  = string
          app_secret              = optional(string)
          app_secret_setting_name = optional(string)
          oauth_scopes            = optional(list(string))
        }))
        github = optional(object({
          client_id                  = string
          client_secret              = optional(string)
          client_secret_setting_name = optional(string)
          oauth_scopes               = optional(list(string))
        }))
        google = optional(object({
          client_id                  = string
          client_secret              = optional(string)
          client_secret_setting_name = optional(string)
          oauth_scopes               = optional(list(string))
        }))
        microsoft = optional(object({
          client_id                  = string
          client_secret              = optional(string)
          client_secret_setting_name = optional(string)
          oauth_scopes               = optional(list(string))
        }))
        twitter = optional(object({
          consumer_key                 = string
          consumer_secret              = optional(string)
          consumer_secret_setting_name = optional(string)
        }))
      }))
      auth_settings_v2 = optional(object({
        auth_enabled                            = optional(bool)
        runtime_version                         = optional(string)
        config_file_path                        = optional(string)
        require_authentication                  = optional(bool)
        unauthenticated_action                  = optional(string)
        default_provider                        = optional(string)
        excluded_paths                          = optional(list(string))
        require_https                           = optional(bool)
        http_route_api_prefix                   = optional(string)
        forward_proxy_convention                = optional(string)
        forward_proxy_custom_host_header_name   = optional(string)
        forward_proxy_custom_scheme_header_name = optional(string)
        login = optional(object({
          logout_endpoint                   = optional(string)
          token_store_enabled               = optional(bool)
          token_refresh_extension_time      = optional(number)
          token_store_path                  = optional(string)
          token_store_sas_setting_name      = optional(string)
          preserve_url_fragments_for_logins = optional(bool)
          allowed_external_redirect_urls    = optional(list(string))
          cookie_expiration_convention      = optional(string)
          cookie_expiration_time            = optional(string)
          validate_nonce                    = optional(bool)
          nonce_expiration_time             = optional(string)
        }))
        apple_v2 = optional(object({
          client_id                  = string
          client_secret_setting_name = string
          login_scopes               = optional(list(string))
        }))
        active_directory_v2 = optional(object({
          client_id                            = string
          tenant_auth_endpoint                 = string
          client_secret_setting_name           = optional(string)
          client_secret_certificate_thumbprint = optional(string)
          jwt_allowed_groups                   = optional(list(string), [])
          jwt_allowed_client_applications      = optional(list(string), [])
          www_authentication_disabled          = optional(bool)
          allowed_applications                 = optional(list(string), [])
          allowed_audiences                    = optional(list(string), [])
          allowed_groups                       = optional(list(string), [])
          allowed_identities                   = optional(list(string), [])
          login_parameters                     = optional(map(string), {})
        }))
        azure_static_web_app_v2 = optional(object({
          client_id = string
        }))
        custom_oidc_v2 = optional(map(object({
          name                          = string
          client_id                     = string
          openid_configuration_endpoint = string
          name_claim_type               = optional(string)
          scopes                        = optional(list(string), [])
          client_credential_method      = optional(string)
          client_secret_setting_name    = optional(string)
          authorisation_endpoint        = optional(string)
          token_endpoint                = optional(string)
          issuer_endpoint               = optional(string)
          certification_uri             = optional(string)
        })))
        facebook_v2 = optional(object({
          app_id                  = string
          app_secret_setting_name = string
          graph_api_version       = optional(string)
          login_scopes            = optional(list(string), [])
        }))
        github_v2 = optional(object({
          client_id                  = string
          client_secret_setting_name = string
          login_scopes               = optional(list(string), [])
        }))
        google_v2 = optional(object({
          client_id                  = string
          client_secret_setting_name = string
          allowed_audiences          = optional(list(string), [])
          login_scopes               = optional(list(string), [])
        }))
        microsoft_v2 = optional(object({
          client_id                  = string
          client_secret_setting_name = string
          allowed_audiences          = optional(list(string), [])
          login_scopes               = optional(list(string), [])
        }))
        twitter_v2 = optional(object({
          consumer_key                 = string
          consumer_secret_setting_name = string
        }))
      }))
      backup = optional(object({
        enabled             = optional(bool)
        name                = string
        storage_account_url = string
        schedule = object({
          frequency_interval       = number
          frequency_unit           = string
          keep_at_least_one_backup = optional(bool)
          retention_period_days    = optional(number)
          start_time               = optional(string)
        })
      }))
      connection_strings = optional(map(object({
        name  = string
        type  = string
        value = string
      })), {})
      logs = optional(object({
        detailed_error_messages = optional(bool)
        failed_request_tracing  = optional(bool)
        application_logs = optional(object({
          file_system_level = string
          azure_blob_storage = optional(object({
            level             = string
            sas_url           = string
            retention_in_days = optional(number, 0)
          }))
        }))
        http_logs = optional(object({
          azure_blob_storage = optional(object({
            sas_url           = string
            retention_in_days = optional(number, 0)
          }))
          file_system = optional(object({
            retention_in_days = optional(number, 0)
            retention_in_mb   = number
          }))
        }))
      }))
      storage_accounts = optional(map(object({
        access_key   = string
        account_name = string
        name         = optional(string)
        share_name   = string
        type         = string
        mount_path   = optional(string)
      })), {})
    })), {})
  })

  validation {
    condition     = contains(["windows", "linux"], var.web_app.type)
    error_message = "The instance type must be either 'windows' or 'linux'."
  }

  validation {
    condition     = var.web_app.location != null || var.location != null
    error_message = "Location must be provided either in the instance object or as a separate variable."
  }

  validation {
    condition     = var.web_app.resource_group_name != null || var.resource_group_name != null
    error_message = "Resource group name must be provided either in the instance object or as a separate variable."
  }
}

variable "location" {
  description = "default azure region to be used"
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "default resource group to be used"
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
