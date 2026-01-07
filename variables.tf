variable "instance" {
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
    client_certificate_mode                        = optional(string, "Required")
    client_certificate_exclusion_paths             = optional(string)
    enabled                                        = optional(bool, true)
    ftp_publish_basic_authentication_enabled       = optional(bool, true)
    https_only                                     = optional(bool, false)
    public_network_access_enabled                  = optional(bool, true)
    key_vault_reference_identity_id                = optional(string)
    virtual_network_subnet_id                      = optional(string)
    vnet_image_pull_enabled                        = optional(bool, false)
    virtual_network_image_pull_enabled             = optional(bool, false)
    webdeploy_publish_basic_authentication_enabled = optional(bool, true)
    zip_deploy_file                                = optional(string)
    virtual_network_backup_restore_enabled         = optional(bool, false)
    tags                                           = optional(map(string))
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }), null)
    site_config = object({
      always_on                                     = optional(bool, true)
      api_definition_url                            = optional(string)
      api_management_api_id                         = optional(string)
      app_command_line                              = optional(string)
      container_registry_managed_identity_client_id = optional(string)
      container_registry_use_managed_identity       = optional(bool)
      default_documents                             = optional(list(string))
      ftps_state                                    = optional(string, "Disabled")
      health_check_path                             = optional(string)
      health_check_eviction_time_in_min             = optional(number)
      http2_enabled                                 = optional(bool)
      ip_restriction_default_action                 = optional(string, "Allow")
      load_balancing_mode                           = optional(string)
      local_mysql_enabled                           = optional(bool, false)
      managed_pipeline_mode                         = optional(string, "Integrated")
      minimum_tls_version                           = optional(string, "1.2")
      remote_debugging_enabled                      = optional(bool, false)
      scm_ip_restriction_default_action             = optional(string, "Allow")
      scm_use_main_ip_restriction                   = optional(bool)
      use_32_bit_worker                             = optional(bool, true)
      vnet_route_all_enabled                        = optional(bool, false)
      websockets_enabled                            = optional(bool, false)
      worker_count                                  = optional(number)
      scm_minimum_tls_version                       = optional(string, "1.2")
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
        ruby_version                 = optional(string)
        current_stack                = optional(string)
        dotnet_core_version          = optional(string)
        tomcat_version               = optional(string)
        java_embedded_server_enabled = optional(bool)
        python                       = optional(bool, false)
      }), null)
      auto_heal_setting = optional(object({
        action = object({
          action_type                    = string
          minimum_process_execution_time = optional(string)
        })
        trigger = object({
          private_memory_kb = optional(number)
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
            path       = optional(string)
          }), null)
          status_code = optional(object({
            count             = number
            interval          = string
            status_code_range = string
            path              = optional(string)
            sub_status        = optional(string)
            win32_status_code = optional(string)
          }), null)
        })
      }), null)
      cors = optional(object({
        allowed_origins     = optional(list(string))
        support_credentials = optional(bool, false)
      }), null)
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
        action                    = optional(string, "Allow")
        ip_address                = optional(string)
        priority                  = optional(number, 65000)
        service_tag               = optional(string)
        virtual_network_subnet_id = optional(string)
        description               = optional(string)
        headers = optional(object({
          x_azure_fdid      = optional(list(string), [])
          x_fd_health_probe = optional(list(string), [])
          x_forwarded_for   = optional(list(string), [])
          x_forwarded_host  = optional(list(string), [])
        }), null)
      })), {})
      scm_ip_restrictions = optional(map(object({
        name                      = optional(string)
        action                    = optional(string, "Allow")
        ip_address                = optional(string)
        priority                  = optional(number, 65000)
        service_tag               = optional(string)
        virtual_network_subnet_id = optional(string)
        description               = optional(string)
        headers = optional(object({
          x_azure_fdid      = optional(list(string), [])
          x_fd_health_probe = optional(list(string), [])
          x_forwarded_for   = optional(list(string), [])
          x_forwarded_host  = optional(list(string), [])
        }), null)
      })), {})
    })
    auth_settings = optional(object({
      enabled                        = bool
      additional_login_parameters    = optional(map(string))
      allowed_external_redirect_urls = optional(list(string))
      default_provider               = optional(string)
      issuer                         = optional(string)
      runtime_version                = optional(string)
      token_refresh_extension_hours  = optional(number, 72)
      token_store_enabled            = optional(bool, false)
      unauthenticated_client_action  = optional(string)
      active_directory = optional(object({
        client_id                  = string
        allowed_audiences          = list(string)
        client_secret              = optional(string)
        client_secret_setting_name = optional(string)
      }), null)
      facebook = optional(object({
        app_id                  = string
        app_secret              = optional(string)
        app_secret_setting_name = optional(string)
        oauth_scopes            = optional(list(string))
      }), null)
      github = optional(object({
        client_id                  = string
        client_secret              = optional(string)
        client_secret_setting_name = optional(string)
        oauth_scopes               = optional(list(string))
      }), null)
      google = optional(object({
        client_id                  = string
        client_secret              = optional(string)
        client_secret_setting_name = optional(string)
        oauth_scopes               = optional(list(string))
      }), null)
      microsoft = optional(object({
        client_id                  = string
        client_secret              = optional(string)
        client_secret_setting_name = optional(string)
        oauth_scopes               = optional(list(string))
      }), null)
      twitter = optional(object({
        consumer_key                 = string
        consumer_secret              = optional(string)
        consumer_secret_setting_name = optional(string)
      }), null)
    }), null)
    auth_settings_v2 = optional(object({
      auth_enabled                            = optional(bool)
      runtime_version                         = optional(string, "~1")
      config_file_path                        = optional(string)
      require_authentication                  = optional(bool)
      unauthenticated_action                  = optional(string)
      default_provider                        = optional(string)
      excluded_paths                          = optional(list(string))
      require_https                           = optional(bool, true)
      http_route_api_prefix                   = optional(string, "/.auth")
      forward_proxy_convention                = optional(string, "NoProxy")
      forward_proxy_custom_host_header_name   = optional(string)
      forward_proxy_custom_scheme_header_name = optional(string)
      login = optional(object({
        logout_endpoint                   = optional(string)
        token_store_enabled               = optional(bool, false)
        token_refresh_extension_time      = optional(number, 72)
        token_store_path                  = optional(string)
        token_store_sas_setting_name      = optional(string)
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
        login_scopes               = optional(list(string))
      }), null)
      active_directory_v2 = optional(object({
        client_id                            = string
        tenant_auth_endpoint                 = string
        client_secret_setting_name           = optional(string)
        client_secret_certificate_thumbprint = optional(string)
        jwt_allowed_groups                   = optional(list(string), [])
        jwt_allowed_client_applications      = optional(list(string), [])
        www_authentication_disabled          = optional(bool, false)
        allowed_applications                 = optional(list(string), [])
        allowed_audiences                    = optional(list(string), [])
        allowed_groups                       = optional(list(string), [])
        allowed_identities                   = optional(list(string), [])
        login_parameters                     = optional(map(string), {})
      }), null)
      azure_static_web_app_v2 = optional(object({
        client_id = string
      }), null)
      custom_oidc_v2 = optional(map(object({
        name                          = string
        client_id                     = string
        openid_configuration_endpoint = string
        name_claim_type               = optional(string)
        scopes                        = optional(list(string), [])
        client_credential_method      = optional(string)
        client_secret_setting_name    = optional(string, null)
        authorisation_endpoint        = optional(string)
        token_endpoint                = optional(string)
        issuer_endpoint               = optional(string)
        certification_uri             = optional(string)
      })), {})
      facebook_v2 = optional(object({
        app_id                  = string
        app_secret_setting_name = string
        graph_api_version       = optional(string)
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
        start_time               = optional(string)
      })
    }), null)
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
    storage_accounts = optional(map(object({
      access_key   = string
      account_name = string
      name         = string
      share_name   = string
      type         = string
      mount_path   = optional(string)
    })), {})
    sticky_settings = optional(object({
      app_setting_names       = optional(list(string), [])
      connection_string_names = optional(list(string), [])
    }), null)
    slots = optional(map(object({
      name                                           = optional(string)
      app_settings                                   = optional(map(string), {})
      client_affinity_enabled                        = optional(bool)
      client_certificate_enabled                     = optional(bool)
      client_certificate_mode                        = optional(string, "Required")
      client_certificate_exclusion_paths             = optional(string)
      enabled                                        = optional(bool, true)
      ftp_publish_basic_authentication_enabled       = optional(bool, true)
      https_only                                     = optional(bool, false)
      public_network_access_enabled                  = optional(bool, true)
      key_vault_reference_identity_id                = optional(string)
      virtual_network_subnet_id                      = optional(string)
      vnet_image_pull_enabled                        = optional(bool, false)
      virtual_network_image_pull_enabled             = optional(bool, false)
      webdeploy_publish_basic_authentication_enabled = optional(bool, true)
      zip_deploy_file                                = optional(string)
      virtual_network_backup_restore_enabled         = optional(bool, false)
      service_plan_id                                = optional(string)
      tags                                           = optional(map(string))
      identity = optional(object({
        type         = string
        identity_ids = optional(list(string))
      }), null)
      site_config = object({
        always_on                                     = optional(bool, true)
        api_definition_url                            = optional(string)
        api_management_api_id                         = optional(string)
        app_command_line                              = optional(string)
        container_registry_managed_identity_client_id = optional(string)
        container_registry_use_managed_identity       = optional(bool)
        default_documents                             = optional(list(string))
        ftps_state                                    = optional(string, "Disabled")
        health_check_path                             = optional(string)
        health_check_eviction_time_in_min             = optional(number)
        http2_enabled                                 = optional(bool)
        ip_restriction_default_action                 = optional(string, "Allow")
        load_balancing_mode                           = optional(string)
        local_mysql_enabled                           = optional(bool, false)
        managed_pipeline_mode                         = optional(string, "Integrated")
        minimum_tls_version                           = optional(string, "1.2")
        remote_debugging_enabled                      = optional(bool, false)
        scm_ip_restriction_default_action             = optional(string, "Allow")
        scm_use_main_ip_restriction                   = optional(bool)
        use_32_bit_worker                             = optional(bool, true)
        vnet_route_all_enabled                        = optional(bool, false)
        websockets_enabled                            = optional(bool, false)
        worker_count                                  = optional(number)
        remote_debugging_version                      = optional(string)
        scm_minimum_tls_version                       = optional(string, "1.2")
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
          python                       = optional(bool, false)
        }), null)
        auto_heal_setting = optional(object({
          action = object({
            action_type                    = string
            minimum_process_execution_time = optional(string)
            custom_action = optional(object({
              executable = string
              parameters = optional(string)
            }), null)
          })
          trigger = object({
            private_memory_kb = optional(number)
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
              path       = optional(string)
            }), null)
            status_code = optional(object({
              count             = number
              interval          = string
              status_code_range = string
              path              = optional(string)
              sub_status        = optional(string)
              win32_status_code = optional(string)
            }), null)
          })
        }), null)
        cors = optional(object({
          allowed_origins     = optional(list(string))
          support_credentials = optional(bool, false)
        }), null)
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
          action                    = optional(string, "Allow")
          ip_address                = optional(string)
          priority                  = optional(number, 65000)
          service_tag               = optional(string)
          virtual_network_subnet_id = optional(string)
          description               = optional(string)
          headers = optional(object({
            x_azure_fdid      = optional(list(string), [])
            x_fd_health_probe = optional(list(string), [])
            x_forwarded_for   = optional(list(string), [])
            x_forwarded_host  = optional(list(string), [])
          }), null)
        })), {})
        scm_ip_restrictions = optional(map(object({
          name                      = optional(string)
          action                    = optional(string, "Allow")
          ip_address                = optional(string)
          priority                  = optional(number, 65000)
          service_tag               = optional(string)
          virtual_network_subnet_id = optional(string)
          description               = optional(string)
          headers = optional(object({
            x_azure_fdid      = optional(list(string), [])
            x_fd_health_probe = optional(list(string), [])
            x_forwarded_for   = optional(list(string), [])
            x_forwarded_host  = optional(list(string), [])
          }), null)
        })), {})
      })
      auth_settings = optional(object({
        enabled                        = bool
        additional_login_parameters    = optional(map(string))
        allowed_external_redirect_urls = optional(list(string))
        default_provider               = optional(string)
        issuer                         = optional(string)
        runtime_version                = optional(string)
        token_refresh_extension_hours  = optional(number, 72)
        token_store_enabled            = optional(bool, false)
        unauthenticated_client_action  = optional(string)
        active_directory = optional(object({
          client_id                  = string
          allowed_audiences          = list(string)
          client_secret              = optional(string)
          client_secret_setting_name = optional(string)
        }), null)
        facebook = optional(object({
          app_id                  = string
          app_secret              = optional(string)
          app_secret_setting_name = optional(string)
          oauth_scopes            = optional(list(string))
        }), null)
        github = optional(object({
          client_id                  = string
          client_secret              = optional(string)
          client_secret_setting_name = optional(string)
          oauth_scopes               = optional(list(string))
        }), null)
        google = optional(object({
          client_id                  = string
          client_secret              = optional(string)
          client_secret_setting_name = optional(string)
          oauth_scopes               = optional(list(string))
        }), null)
        microsoft = optional(object({
          client_id                  = string
          client_secret              = optional(string)
          client_secret_setting_name = optional(string)
          oauth_scopes               = optional(list(string))
        }), null)
        twitter = optional(object({
          consumer_key                 = string
          consumer_secret              = optional(string)
          consumer_secret_setting_name = optional(string)
        }), null)
      }), null)
      auth_settings_v2 = optional(object({
        auth_enabled                            = optional(bool)
        runtime_version                         = optional(string, "~1")
        config_file_path                        = optional(string)
        require_authentication                  = optional(bool)
        unauthenticated_action                  = optional(string)
        default_provider                        = optional(string)
        excluded_paths                          = optional(list(string))
        require_https                           = optional(bool, true)
        http_route_api_prefix                   = optional(string, "/.auth")
        forward_proxy_convention                = optional(string, "NoProxy")
        forward_proxy_custom_host_header_name   = optional(string)
        forward_proxy_custom_scheme_header_name = optional(string)
        login = optional(object({
          logout_endpoint                   = optional(string)
          token_store_enabled               = optional(bool, false)
          token_refresh_extension_time      = optional(number, 72)
          token_store_path                  = optional(string)
          token_store_sas_setting_name      = optional(string)
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
          login_scopes               = optional(list(string))
        }), null)
        active_directory_v2 = optional(object({
          client_id                            = string
          tenant_auth_endpoint                 = string
          client_secret_setting_name           = optional(string)
          client_secret_certificate_thumbprint = optional(string)
          jwt_allowed_groups                   = optional(list(string), [])
          jwt_allowed_client_applications      = optional(list(string), [])
          www_authentication_disabled          = optional(bool, false)
          allowed_applications                 = optional(list(string), [])
          allowed_audiences                    = optional(list(string), [])
          allowed_groups                       = optional(list(string), [])
          allowed_identities                   = optional(list(string), [])
          login_parameters                     = optional(map(string), {})
        }), null)
        azure_static_web_app_v2 = optional(object({
          client_id = string
        }), null)
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
        })), {})
        facebook_v2 = optional(object({
          app_id                  = string
          app_secret_setting_name = string
          graph_api_version       = optional(string)
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
          start_time               = optional(string)
        })
      }), null)
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
      storage_accounts = optional(map(object({
        access_key   = string
        account_name = string
        name         = string
        share_name   = string
        type         = string
        mount_path   = optional(string)
      })), {})
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
    condition     = var.instance.resource_group_name != null || var.resource_group_name != null
    error_message = "Resource group name must be provided either in the instance object or as a separate variable."
  }

  validation {
    condition     = var.instance.client_certificate_enabled != true || var.instance.client_certificate_mode != null
    error_message = "When client_certificate_enabled is true, client_certificate_mode must be specified (Required or Optional)."
  }

  validation {
    condition     = !(var.instance.auth_settings != null && var.instance.auth_settings_v2 != null)
    error_message = "Cannot configure both auth_settings and auth_settings_v2. Use only one authentication configuration."
  }

  validation {
    condition = var.instance.auth_settings == null || (
      var.instance.auth_settings.active_directory == null ||
      var.instance.auth_settings.active_directory.client_secret != null ||
      var.instance.auth_settings.active_directory.client_secret_setting_name != null
    )
    error_message = "When using Active Directory authentication, either client_secret or client_secret_setting_name must be provided."
  }

  validation {
    condition     = var.instance.backup == null || contains(["Day", "Hour"], var.instance.backup.schedule.frequency_unit)
    error_message = "Backup frequency_unit must be either 'Day' or 'Hour'."
  }

  validation {
    condition = var.instance.backup == null || (
      var.instance.backup.schedule.frequency_unit == "Day" && var.instance.backup.schedule.frequency_interval >= 1 && var.instance.backup.schedule.frequency_interval <= 1000
      ) || (
      var.instance.backup.schedule.frequency_unit == "Hour" && var.instance.backup.schedule.frequency_interval >= 1 && var.instance.backup.schedule.frequency_interval <= 23
    )
    error_message = "For backup schedule: frequency_interval must be 1-1000 for 'Day' or 1-23 for 'Hour'."
  }

  validation {
    condition = var.instance.backup == null || (
      var.instance.backup.schedule.retention_period_days >= 1 && var.instance.backup.schedule.retention_period_days <= 9999999
    )
    error_message = "Backup retention_period_days must be between 1 and 9999999 days."
  }

  validation {
    condition = var.instance.site_config.auto_heal_setting == null || (
      var.instance.site_config.auto_heal_setting.action.action_type != "CustomAction" ||
      var.instance.site_config.auto_heal_setting.action.custom_action != null
    )
    error_message = "When auto-heal action_type is 'CustomAction', custom_action configuration must be provided."
  }

  validation {
    condition = var.instance.site_config.ip_restrictions == null || alltrue([
      for restriction in values(var.instance.site_config.ip_restrictions) :
      length([
        for source in [restriction.ip_address, restriction.service_tag, restriction.virtual_network_subnet_id] :
        source if source != null
      ]) == 1
    ])
    error_message = "Each IP restriction must specify exactly one source: ip_address, service_tag, or virtual_network_subnet_id."
  }

  validation {
    condition     = var.instance.virtual_network_subnet_id == null || var.instance.site_config.vnet_route_all_enabled != null
    error_message = "When using virtual_network_subnet_id, vnet_route_all_enabled should be explicitly configured."
  }

  validation {
    condition = var.instance.site_config.container_registry_use_managed_identity != true || (
      var.instance.site_config.container_registry_managed_identity_client_id != null ||
      var.instance.identity != null
    )
    error_message = "When container_registry_use_managed_identity is true, either container_registry_managed_identity_client_id must be provided or managed identity must be enabled."
  }

  validation {
    condition = var.instance.site_config.application_stack == null || (
      var.instance.type == "windows" || (
        length([
          for runtime in [
            var.instance.site_config.application_stack.dotnet_version,
            var.instance.site_config.application_stack.java_version,
            var.instance.site_config.application_stack.node_version,
            var.instance.site_config.application_stack.php_version,
            var.instance.site_config.application_stack.python_version,
            var.instance.site_config.application_stack.ruby_version,
            var.instance.site_config.application_stack.go_version,
            var.instance.site_config.application_stack.docker_image_name
          ] : runtime if runtime != null
        ]) <= 1
      )
    )
    error_message = "For Linux apps, only one runtime can be specified in the application stack."
  }

  validation {
    condition = var.instance.site_config.application_stack == null || (
      var.instance.site_config.application_stack.docker_image_name == null ||
      var.instance.site_config.application_stack.docker_registry_url != null
    )
    error_message = "When using docker_image_name, docker_registry_url must be provided."
  }

  validation {
    condition = var.instance.logs == null || var.instance.logs.application_logs == null || contains([
      "Off", "Verbose", "Information", "Warning", "Error"
    ], var.instance.logs.application_logs.file_system_level)
    error_message = "Application logs file_system_level must be one of: Off, Verbose, Information, Warning, Error."
  }

  validation {
    condition = var.instance.logs == null || var.instance.logs.application_logs == null || var.instance.logs.application_logs.azure_blob_storage == null || contains([
      "Off", "Verbose", "Information", "Warning", "Error"
    ], var.instance.logs.application_logs.azure_blob_storage.level)
    error_message = "Application logs azure_blob_storage level must be one of: Off, Verbose, Information, Warning, Error."
  }

  validation {
    condition = var.instance.logs == null || var.instance.logs.http_logs == null || !(
      var.instance.logs.http_logs.azure_blob_storage != null &&
      var.instance.logs.http_logs.file_system != null
    )
    error_message = "HTTP logs cannot be configured for both azure_blob_storage and file_system simultaneously."
  }

  validation {
    condition     = var.instance.key_vault_reference_identity_id == null || var.instance.identity != null
    error_message = "When using key_vault_reference_identity_id, managed identity must be configured."
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
