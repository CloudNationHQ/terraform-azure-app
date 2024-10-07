# linux web app
resource "azurerm_linux_web_app" "linux" {
  for_each = var.instance.type == "linux" ? {
    (var.instance.name) = var.instance
  } : {}

  name                                           = var.instance.name
  location                                       = coalesce(lookup(var.instance, "location", null), var.location)
  resource_group_name                            = coalesce(lookup(var.instance, "resource_group", null), var.resource_group)
  service_plan_id                                = var.instance.service_plan_id
  app_settings                                   = {}
  client_affinity_enabled                        = try(var.instance.client_affinity_enabled, null)
  client_certificate_enabled                     = try(var.instance.client_certificate_enabled, null)
  client_certificate_mode                        = try(var.instance.client_certificate_mode, "Required")
  client_certificate_exclusion_paths             = try(var.instance.client_certificate_exclusion_paths, null)
  enabled                                        = try(var.instance.enabled, true)
  ftp_publish_basic_authentication_enabled       = try(var.instance.ftp_publish_basic_authentication_enabled, true)
  https_only                                     = try(var.instance.https_only, false)
  public_network_access_enabled                  = try(var.instance.public_network_access_enabled, true)
  key_vault_reference_identity_id                = try(var.instance.key_vault_reference_identity_id, null)
  virtual_network_subnet_id                      = try(var.instance.virtual_network_subnet_id, null)
  webdeploy_publish_basic_authentication_enabled = try(var.instance.webdeploy_publish_basic_authentication_enabled, true)
  zip_deploy_file                                = try(var.instance.zip_deploy_file, null)
  tags                                           = try(var.instance.tags, var.tags, {})

  # block
  site_config {
    always_on                                     = try(var.instance.site_config.always_on, true)
    api_definition_url                            = try(var.instance.site_config.api_definition_url, null)
    api_management_api_id                         = try(var.instance.site_config.api_management_api_id, null)
    app_command_line                              = try(var.instance.site_config.app_command_line, null)
    container_registry_managed_identity_client_id = try(var.instance.site_config.container_registry_managed_identity_client_id, null)
    container_registry_use_managed_identity       = try(var.instance.site_config.container_registry_use_managed_identity, null)
    default_documents                             = try(var.instance.site_config.default_documents, null)
    ftps_state                                    = try(var.instance.site_config.ftps_state, "Disabled")
    health_check_path                             = try(var.instance.site_config.health_check_path, null)
    health_check_eviction_time_in_min             = try(var.instance.site_config.health_check_eviction_time_in_min, null)
    http2_enabled                                 = try(var.instance.site_config.http2_enabled, null)
    ip_restriction_default_action                 = try(var.instance.site_config.ip_restriction_default_action, null)
    load_balancing_mode                           = try(var.instance.site_config.load_balancing_mode, null)
    local_mysql_enabled                           = try(var.instance.site_config.local_mysql_enabled, false)
    managed_pipeline_mode                         = try(var.instance.site_config.managed_pipeline_mode, "Integrated")
    minimum_tls_version                           = try(var.instance.site_config.minimum_tls_version, "1.2")
    remote_debugging_enabled                      = try(var.instance.site_config.remote_debugging_enabled, false)
    scm_ip_restriction_default_action             = try(var.instance.site_config.scm_ip_restriction_default_action, "Allow")
    scm_use_main_ip_restriction                   = try(var.instance.site_config.scm_use_main_ip_restriction, null)
    use_32_bit_worker                             = try(var.instance.site_config.use_32_bit_worker, true)
    vnet_route_all_enabled                        = try(var.instance.site_config.vnet_route_all_enabled, false)
    websockets_enabled                            = try(var.instance.site_config.websockets_enabled, false)
    worker_count                                  = try(var.instance.site_config.worker_count, null)

    dynamic "application_stack" {
      for_each = lookup(each.value.site_config, "application_stack", null) != null ? [lookup(each.value.site_config, "application_stack")] : []

      content {
        docker_image_name        = try(application_stack.value.docker_image_name, null)
        docker_registry_url      = try(application_stack.value.docker_registry_url, null)
        docker_registry_username = try(application_stack.value.docker_registry_username, null)
        docker_registry_password = try(application_stack.value.docker_registry_password, null)
        dotnet_version           = try(application_stack.value.dotnet_version, null)
        go_version               = try(application_stack.value.go_version, null)
        java_server              = try(application_stack.value.java_server, null)
        java_server_version      = try(application_stack.value.java_server_version, null)
        java_version             = try(application_stack.value.java_version, null)
        node_version             = try(application_stack.value.node_version, null)
        php_version              = try(application_stack.value.php_version, null)
        python_version           = try(application_stack.value.python_version, null)
        ruby_version             = try(application_stack.value.ruby_version, null)
      }
    }

    dynamic "auto_heal_setting" {
      for_each = lookup(each.value.site_config, "auto_heal_setting", null) != null ? [lookup(each.value.site_config, "auto_heal_setting")] : []

      content {
        dynamic "action" {
          for_each = lookup(auto_heal_setting.value, "action", null) != null ? [lookup(auto_heal_setting.value, "action")] : []
          content {
            action_type                    = action.value.action_type
            minimum_process_execution_time = try(action.value.minimum_process_execution_time, null)
          }
        }

        dynamic "trigger" {
          for_each = lookup(auto_heal_setting.value, "trigger", null) != null ? [lookup(auto_heal_setting.value, "trigger")] : []
          content {
            dynamic "requests" {
              for_each = lookup(trigger.value, "requests", null) != null ? [lookup(trigger.value, "requests")] : []
              content {
                count    = requests.value.count
                interval = requests.value.interval
              }
            }
            dynamic "slow_request" {
              for_each = lookup(trigger.value, "slow_request", null) != null ? [lookup(trigger.value, "slow_request")] : []
              content {
                count      = slow_requests.value.count
                interval   = slow_requests.value.interval
                time_taken = slow_requests.value.time_taken
              }
            }
            dynamic "slow_request_with_path" {
              for_each = lookup(trigger.value, "slow_request_with_path", null) != null ? [lookup(trigger.value, "slow_request_with_path")] : []
              content {
                count      = slow_requests.value.count
                interval   = slow_requests.value.interval
                time_taken = slow_requests.value.time_taken
                path       = try(slow_requests.value.path, null)
              }
            }
            dynamic "status_code" {
              for_each = lookup(trigger.value, "status_code", null) != null ? [lookup(trigger.value, "status_code")] : []
              content {
                count             = status_code.value.count
                interval          = status_code.value.interval
                status_code_range = status_code.value.status_code_range
                path              = try(status_code.value.path, null)
                sub_status        = try(status_code.value.sub_status, null)
                win32_status_code = try(status_code.value.win32_status_code, null)
              }
            }
          }
        }
      }
    }

    dynamic "cors" {
      for_each = lookup(each.value.site_config, "cors", null) != null ? [lookup(each.value.site_config, "cors")] : []
      content {
        allowed_origins     = try(cors.value.allowed_origins, null)
        support_credentials = try(cors.value.support_credentials, false)
      }
    }

    dynamic "ip_restriction" {
      for_each = {
        for key, ip_restriction in lookup(each.value.site_config, "ip_restrictions", []) : key => ip_restriction
      }
      content {
        name                      = try(ip_restriction.value.name, each.key)
        action                    = try(ip_restriction.value.action, "Allow")
        ip_address                = try(ip_restriction.value.ip_address, null)
        priority                  = try(ip_restriction.value.priority, 65000)
        service_tag               = try(ip_restriction.value.service_tag, null)
        virtual_network_subnet_id = try(ip_restriction.value.virtual_network_subnet_id, null)
        description               = try(ip_restriction.value.description, null)

        dynamic "headers" {
          for_each = lookup(ip_restriction.value, "headers", null) != null ? [lookup(ip_restriction.value, "headers")] : []
          content {
            x_azure_fdid      = try(headers.value.x_azure_fdid, [])
            x_fd_health_probe = try(headers.value.x_fd_health_probe, null)
            x_forwarded_for   = try(headers.value.x_forwarded_for, [])
            x_forwarded_host  = try(headers.value.x_forwarded_host, [])
          }
        }
      }
    }

    dynamic "scm_ip_restriction" {
      for_each = {
        for key, ip_restriction in lookup(each.value.site_config, "scm_ip_restrictions", []) : key => ip_restriction
      }
      content {
        action                    = try(scm_ip_restriction.value.action, "Allow")
        ip_address                = try(scm_ip_restriction.value.ip_address, null)
        name                      = try(scm_ip_restriction.value.name, null)
        priority                  = try(scm_ip_restriction.value.priority, 65000)
        service_tag               = try(scm_ip_restriction.value.service_tag, null)
        virtual_network_subnet_id = try(scm_ip_restriction.value.virtual_network_subnet_id, null)
        description               = try(scm_ip_restriction.value.description, null)

        dynamic "headers" {
          for_each = lookup(scm_ip_restriction.value, "headers", null) != null ? [lookup(scm_ip_restriction.value, "headers")] : []
          content {
            x_azure_fdid      = try(headers.value.x_azure_fdid, [])
            x_fd_health_probe = try(headers.value.x_fd_health_probe, null)
            x_forwarded_for   = try(headers.value.x_forwarded_for, [])
            x_forwarded_host  = try(headers.value.x_forwarded_host, [])
          }
        }
      }
    }
  }

  dynamic "auth_settings" {
    for_each = try(var.instance.auth_settings, null) != null ? { default = var.instance.auth_settings } : {}
    content {
      enabled                        = auth_settings.value.enabled
      additional_login_parameters    = try(auth_settings.value.additional_login_parameters, null)
      allowed_external_redirect_urls = try(auth_settings.value.allowed_external_redirect_urls, null)
      default_provider               = try(auth_settings.value.default_provider, null)
      issuer                         = try(auth_settings.value.issuer, null)
      runtime_version                = try(auth_settings.value.runtime_version, null)
      token_refresh_extension_hours  = try(auth_settings.value.token_refresh_extension_hours, 72)
      token_store_enabled            = try(auth_settings.value.token_store_enabled, false)
      unauthenticated_client_action  = try(auth_settings.value.unauthenticated_client_action, null)

      dynamic "active_directory" {
        for_each = lookup(auth_settings.value, "active_directory", null) != null ? [lookup(auth_settings.value, "active_directory")] : []

        content {
          client_id                  = active_directory.value.client_id
          allowed_audiences          = active_directory.value.allowed_audiences
          client_secret              = try(active_directory.value.client_secret, null)
          client_secret_setting_name = try(active_directory.value.client_secret_setting_name, null)
        }
      }

      dynamic "facebook" {
        for_each = lookup(auth_settings.value, "facebook", null) != null ? [lookup(auth_settings.value, "facebook")] : []
        content {
          app_id                  = facebook.value.app_id
          app_secret              = try(facebook.value.app_secret, null)
          app_secret_setting_name = try(facebook.value.app_secret_setting_name, null)
          oauth_scopes            = try(facebook.value.oauth_scopes, null)
        }
      }

      dynamic "github" {
        for_each = lookup(auth_settings.value, "github", null) != null ? [lookup(auth_settings.value, "github")] : []
        content {
          client_id                  = github.value.client_id
          client_secret              = try(github.value.client_secret, null)
          client_secret_setting_name = try(github.value.client_secret_setting_name, null)
          oauth_scopes               = try(github.value.oauth_scopes, null)
        }
      }

      dynamic "google" {
        for_each = lookup(auth_settings.value, "google", null) != null ? [lookup(auth_settings.value, "google")] : []
        content {
          client_id                  = google.value.client_id
          client_secret              = try(google.value.client_secret, null)
          client_secret_setting_name = try(google.value.client_secret_setting_name, null)
          oauth_scopes               = try(google.value.oauth_scopes, null)
        }
      }

      dynamic "microsoft" {
        for_each = lookup(auth_settings.value, "microsoft", null) != null ? [lookup(auth_settings.value, "microsoft")] : []
        content {
          client_id                  = microsoft.value.client_id
          client_secret              = try(microsoft.value.client_secret, null)
          client_secret_setting_name = try(microsoft.value.client_secret_setting_name, null)
          oauth_scopes               = try(microsoft.value.oauth_scopes, null)
        }
      }

      dynamic "twitter" {
        for_each = lookup(auth_settings.value, "twitter", null) != null ? [lookup(auth_settings.value, "twitter")] : []
        content {
          consumer_key                 = twitter.value.consumer_key
          consumer_secret              = try(twitter.value.consumer_secret, null)
          consumer_secret_setting_name = try(twitter.value.consumer_secret_setting_name, null)
        }
      }
    }
  }

  dynamic "auth_settings_v2" {
    for_each = try(var.instance.auth_settings_v2, null) != null ? { default = var.instance.auth_settings_v2 } : {}
    content {
      auth_enabled                            = try(auth_settings_v2.value.auth_enabled, null)
      runtime_version                         = try(auth_settings_v2.value.runtime_version, "~1")
      config_file_path                        = try(auth_settings_v2.value.config_file_path, null)
      require_authentication                  = try(auth_settings_v2.value.require_authentication, null)
      unauthenticated_action                  = try(auth_settings_v2.value.unauthenticated_action, null)
      default_provider                        = try(auth_settings_v2.value.default_provider, null)
      excluded_paths                          = try(auth_settings_v2.value.excluded_paths, null)
      require_https                           = try(auth_settings_v2.value.require_https, true)
      http_route_api_prefix                   = try(auth_settings_v2.value.http_route_api_prefix, "/.auth")
      forward_proxy_convention                = try(auth_settings_v2.value.forward_proxy_convention, "NoProxy")
      forward_proxy_custom_host_header_name   = try(auth_settings_v2.value.forward_proxy_custom_host_header_name, null)
      forward_proxy_custom_scheme_header_name = try(auth_settings_v2.value.forward_proxy_custom_scheme_header_name, null)

      dynamic "login" {
        for_each = lookup(auth_settings_v2.value, "login", null) != null ? [lookup(auth_settings_v2.value, "login")] : []
        content {
          logout_endpoint                   = try(login.value.logout_endpoint, null)
          token_store_enabled               = try(login.value.token_store_enabled, false)
          token_refresh_extension_time      = try(login.value.token_refresh_extension_time, 72)
          token_store_path                  = try(login.value.token_store_path, null)
          token_store_sas_setting_name      = try(login.value.token_store_sas_setting_name, null)
          preserve_url_fragments_for_logins = try(login.value.preserve_url_fragments_for_logins, false)
          allowed_external_redirect_urls    = try(login.value.allowed_external_redirect_urls, [])
          cookie_expiration_convention      = try(login.value.cookie_expiration_convention, "FixedTime")
          cookie_expiration_time            = try(login.value.cookie_expiration_time, "08:00:00")
          validate_nonce                    = try(login.value.validate_nonce, true)
          nonce_expiration_time             = try(login.value.nonce_expiration_time, "00:05:00")
        }
      }

      dynamic "apple_v2" {
        for_each = lookup(auth_settings_v2.value, "apple_v2", null) != null ? [lookup(auth_settings_v2.value, "apple_v2")] : []
        content {
          client_id                  = apple_v2.value.client_id
          client_secret_setting_name = apple_v2.value.client_secret_setting_name
          login_scopes               = apple_v2.value.login_scopes

        }
      }

      dynamic "active_directory_v2" {
        for_each = lookup(auth_settings_v2.value, "active_directory_v2", null) != null ? [lookup(auth_settings_v2.value, "active_directory_v2")] : []
        content {
          client_id                            = active_directory_v2.value.client_id
          tenant_auth_endpoint                 = active_directory_v2.value.tenant_auth_endpoint
          client_secret_setting_name           = try(active_directory_v2.value.client_secret_setting_name, null)
          client_secret_certificate_thumbprint = try(active_directory_v2.value.client_secret_certificate_thumbprint, null)
          jwt_allowed_groups                   = try(active_directory_v2.value.jwt_allowed_groups, [])
          jwt_allowed_client_applications      = try(active_directory_v2.value.jwt_allowed_client_applications, [])
          www_authentication_disabled          = try(active_directory_v2.value.www_authentication_disabled, false)
          allowed_applications                 = try(active_directory_v2.value.allowed_applications, [])
          allowed_audiences                    = try(active_directory_v2.value.allowed_audiences, [])
          allowed_groups                       = try(active_directory_v2.value.allowed_groups, [])
          allowed_identities                   = try(active_directory_v2.value.allowed_identities, [])
        }
      }

      dynamic "azure_static_web_app_v2" {
        for_each = lookup(auth_settings_v2.value, "azure_static_web_app_v2", null) != null ? [lookup(auth_settings_v2.value, "azure_static_web_app_v2")] : []
        content {
          client_id = azure_static_web_app_v2.value.client_id
        }
      }

      dynamic "custom_oidc_v2" {
        for_each = lookup(auth_settings_v2.value, "custom_oidc_v2", null) != null ? [lookup(auth_settings_v2.value, "custom_oidc_v2")] : []
        content {
          name                          = custom_oidc_v2.value.name
          client_id                     = custom_oidc_v2.value.client_id
          openid_configuration_endpoint = custom_oidc_v2.value.openid_configuration_endpoint
          name_claim_type               = try(custom_oidc_v2.value.name_clame_type, null)
          scopes                        = try(custom_oidc_v2.value.scopes, [])
          client_credential_method      = try(custom_oidc_v2.value.client_credential_method, null)
          client_secret_setting_name    = try(custom_oidc_v2.value.client_secret_setting_name, "${custom_oidc_v2.value.name}_PROVIDER_AUTHENTICATION_SECRET")
          authorisation_endpoint        = try(custom_oidc_v2.value.authorisation_endpoint, null)
          token_endpoint                = try(custom_oidc_v2.value.token_endpoint, null)
          issuer_endpoint               = try(custom_oidc_v2.value.issuer_endpoint, null)
          certification_uri             = try(custom_oidc_v2.value.certification_uri, null)
        }
      }

      dynamic "facebook_v2" {
        for_each = lookup(auth_settings_v2.value, "facebook_v2", null) != null ? [lookup(auth_settings_v2.value, "facebook_v2")] : []
        content {
          app_id                  = facebook_v2.value.app_id
          app_secret_setting_name = facebook_v2.value.app_secret_setting_name
          graph_api_version       = try(facebook_v2.value.graph_api_version, null)
          login_scopes            = try(facebook_v2.value.login_scopes, [])
        }
      }

      dynamic "github_v2" {
        for_each = lookup(auth_settings_v2.value, "github_v2", null) != null ? [lookup(auth_settings_v2.value, "github_v2")] : []
        content {
          client_id                  = github_v2.value.client_id
          client_secret_setting_name = github_v2.value.client_secret_setting_name
          login_scopes               = try(github_v2.value.login_scopes, [])
        }
      }

      dynamic "google_v2" {
        for_each = lookup(auth_settings_v2.value, "google_v2", null) != null ? [lookup(auth_settings_v2.value, "google_v2")] : []
        content {
          client_id                  = google_v2.value.client_id
          client_secret_setting_name = google_v2.value.client_secret_setting_name
          allowed_audiences          = try(google_v2.value.allowed_audiences, [])
          login_scopes               = try(google_v2.value.login_scopes, [])
        }
      }

      dynamic "microsoft_v2" {
        for_each = lookup(auth_settings_v2.value, "microsoft_v2", null) != null ? [lookup(auth_settings_v2.value, "microsoft_v2")] : []
        content {
          client_id                  = microsoft_v2.value.client_id
          client_secret_setting_name = microsoft_v2.value.client_secret_setting_name
          allowed_audiences          = try(microsoft_v2.value.allowed_audiences, [])
          login_scopes               = try(microsoft_v2.value.login_scopes, [])
        }
      }

      dynamic "twitter_v2" {
        for_each = lookup(auth_settings_v2.value, "twitter_v2", null) != null ? [lookup(auth_settings_v2.value, "twitter_v2")] : []
        content {
          consumer_key                 = twitter_v2.value.consumer_key
          consumer_secret_setting_name = twitter_v2.value.consumer_secret_setting_name
        }
      }
    }
  }

  dynamic "backup" {
    for_each = try(var.instance.backup, null) != null ? { default = var.instance.backup } : {}
    content {
      enabled             = try(backup.value.enabled, true)
      name                = backup.value.name
      storage_account_url = backup.value.storage_account_url

      dynamic "schedule" {
        for_each = lookup(backup.value, "schedule", null) != null ? [lookup(backup.value, "schedule")] : []
        content {
          frequency_interval       = schedule.value.frequency_interval
          frequency_unit           = schedule.value.frequency_unit
          keep_at_least_one_backup = try(schedule.value.keep_at_least_one_backup, false)
          retention_period_days    = try(schedule.value.retention_period_days, 30)
          start_time               = try(schedule.value.start_time, null)
        }
      }
    }
  }

  dynamic "connection_string" {
    for_each = try(var.instance.connection_string, null) != null ? { default = var.instance.connection_string } : {}
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  dynamic "identity" {
    for_each = [lookup(var.instance, "identity", { type = "SystemAssigned", identity_ids = [] })]

    content {
      type = identity.value.type
      identity_ids = concat(
        try([azurerm_user_assigned_identity.identity["identity"].id], []),
        lookup(identity.value, "identity_ids", [])
      )
    }
  }

  dynamic "logs" {
    for_each = try(var.instance.logs, null) != null ? { default = var.instance.logs } : {}
    content {
      detailed_error_messages = try(logs.value.detailed_error_messages, null)
      failed_request_tracing  = try(logs.value.failed_request_tracing, null)

      dynamic "application_logs" {
        for_each = lookup(logs.value, "application_logs", null) != null ? [lookup(logs.value, "application_logs")] : []
        content {
          file_system_level = application_logs.value.file_system_level
          dynamic "azure_blob_storage" {
            for_each = lookup(application_logs.value, "azure_blob_storage", null) != null ? [lookup(application_logs.value, "azure_blob_storage")] : []
            content {
              level             = azure_blob_storage.value.level
              sas_url           = azure_blob_storage.value.sas_url
              retention_in_days = try(azure_blob_storage.value.retention_in_days, 0)
            }
          }
        }
      }

      dynamic "http_logs" {
        for_each = lookup(each.value.logs, "http_logs", null) != null ? [lookup(each.value.logs, "http_logs")] : []
        content {
          dynamic "azure_blob_storage" {
            for_each = lookup(http_logs.value, "azure_blob_storage", null) != null ? [lookup(http_logs.value, "azure_blob_storage")] : []
            content {
              sas_url           = azure_blob_storage.value.sas_url
              retention_in_days = try(azure_blob_storage.value.retention_in_days, 0)
            }
          }
          dynamic "file_system" {
            for_each = lookup(http_logs.value, "file_system", null) != null ? [lookup(http_logs.value, "file_system")] : []
            content {
              retention_in_days = try(file_system.value.retention_in_days, 0)
              retention_in_mb   = file_system.value.retention_in_mb
            }
          }
        }
      }
    }
  }

  dynamic "storage_account" {
    for_each = try(var.instance.storage_account, null) != null ? { default = var.instance.storage_account } : {}
    content {
      access_key   = storage_account.value.access_key
      account_name = storage_account.value.account_name
      name         = storage_account.value.name
      share_name   = storage_account.value.share_name
      type         = storage_account.value.type
      mount_path   = try(storage_account.value.mount_path, null)
    }
  }

  dynamic "sticky_settings" {
    for_each = try(var.instance.sticky_settings, null) != null ? { default = var.instance.sticky_settings } : {}
    content {
      app_setting_names       = try(sticky_settings.value.app_setting_names, [])
      connection_string_names = try(sticky_settings.value.connection_string_names, [])
    }
  }
}

# linux web app slot
resource "azurerm_linux_web_app_slot" "linux" {
  for_each = {
    for key, value in try(var.instance.slots, {}) : key => value
    if var.instance.type == "linux"
  }

  name                                           = try(each.value.name, each.key)
  app_service_id                                 = azurerm_linux_web_app.linux[var.instance.name].id
  app_settings                                   = {}
  client_affinity_enabled                        = try(var.instance.client_affinity_enabled, null)
  client_certificate_enabled                     = try(var.instance.client_certificate_enabled, null)
  client_certificate_mode                        = try(var.instance.client_certificate_mode, "Required")
  client_certificate_exclusion_paths             = try(var.instance.client_certificate_exclusion_paths, null)
  enabled                                        = try(var.instance.enabled, true)
  ftp_publish_basic_authentication_enabled       = try(var.instance.ftp_publish_basic_authentication_enabled, true)
  https_only                                     = try(var.instance.https_only, false)
  public_network_access_enabled                  = try(var.instance.public_network_access_enabled, true)
  key_vault_reference_identity_id                = try(var.instance.key_vault_reference_identity_id, null)
  virtual_network_subnet_id                      = try(var.instance.virtual_network_subnet_id, null)
  webdeploy_publish_basic_authentication_enabled = try(var.instance.webdeploy_publish_basic_authentication_enabled, true)
  zip_deploy_file                                = try(var.instance.zip_deploy_file, null)
  tags                                           = try(var.instance.tags, var.tags, {})

  site_config {
    always_on                                     = try(var.instance.site_config.always_on, true)
    api_definition_url                            = try(var.instance.site_config.api_definition_url, null)
    api_management_api_id                         = try(var.instance.site_config.api_management_api_id, null)
    app_command_line                              = try(var.instance.site_config.app_command_line, null)
    container_registry_managed_identity_client_id = try(var.instance.site_config.container_registry_managed_identity_client_id, null)
    container_registry_use_managed_identity       = try(var.instance.site_config.container_registry_use_managed_identity, null)
    default_documents                             = try(var.instance.site_config.default_documents, null)
    ftps_state                                    = try(var.instance.site_config.ftps_state, "Disabled")
    health_check_path                             = try(var.instance.site_config.health_check_path, null)
    health_check_eviction_time_in_min             = try(var.instance.site_config.health_check_eviction_time_in_min, null)
    http2_enabled                                 = try(var.instance.site_config.http2_enabled, null)
    ip_restriction_default_action                 = try(var.instance.site_config.ip_restriction_default_action, null)
    load_balancing_mode                           = try(var.instance.site_config.load_balancing_mode, null)
    local_mysql_enabled                           = try(var.instance.site_config.local_mysql_enabled, false)
    managed_pipeline_mode                         = try(var.instance.site_config.managed_pipeline_mode, "Integrated")
    minimum_tls_version                           = try(var.instance.site_config.minimum_tls_version, "1.2")
    remote_debugging_enabled                      = try(var.instance.site_config.remote_debugging_enabled, false)
    scm_ip_restriction_default_action             = try(var.instance.site_config.scm_ip_restriction_default_action, "Allow")
    scm_use_main_ip_restriction                   = try(var.instance.site_config.scm_use_main_ip_restriction, null)
    use_32_bit_worker                             = try(var.instance.site_config.use_32_bit_worker, true)
    vnet_route_all_enabled                        = try(var.instance.site_config.vnet_route_all_enabled, false)
    websockets_enabled                            = try(var.instance.site_config.websockets_enabled, false)
    worker_count                                  = try(var.instance.site_config.worker_count, null)

    dynamic "application_stack" {
      for_each = lookup(each.value.site_config, "application_stack", null) != null ? [lookup(each.value.site_config, "application_stack")] : []

      content {
        docker_image_name        = try(application_stack.value.docker_image_name, null)
        docker_registry_url      = try(application_stack.value.docker_registry_url, null)
        docker_registry_username = try(application_stack.value.docker_registry_username, null)
        docker_registry_password = try(application_stack.value.docker_registry_password, null)
        dotnet_version           = try(application_stack.value.dotnet_version, null)
        go_version               = try(application_stack.value.go_version, null)
        java_server              = try(application_stack.value.java_server, null)
        java_server_version      = try(application_stack.value.java_server_version, null)
        java_version             = try(application_stack.value.java_version, null)
        node_version             = try(application_stack.value.node_version, null)
        php_version              = try(application_stack.value.php_version, null)
        python_version           = try(application_stack.value.python_version, null)
        ruby_version             = try(application_stack.value.ruby_version, null)
      }
    }

    dynamic "auto_heal_setting" {
      for_each = lookup(each.value.site_config, "auto_heal_setting", null) != null ? [lookup(each.value.site_config, "auto_heal_setting")] : []

      content {
        dynamic "action" {
          for_each = lookup(auto_heal_setting.value, "action", null) != null ? [lookup(auto_heal_setting.value, "action")] : []
          content {
            action_type                    = action.value.action_type
            minimum_process_execution_time = try(action.value.minimum_process_execution_time, null)
          }
        }

        dynamic "trigger" {
          for_each = lookup(auto_heal_setting.value, "trigger", null) != null ? [lookup(auto_heal_setting.value, "trigger")] : []
          content {
            dynamic "requests" {
              for_each = lookup(trigger.value, "requests", null) != null ? [lookup(trigger.value, "requests")] : []
              content {
                count    = requests.value.count
                interval = requests.value.interval
              }
            }
            dynamic "slow_request" {
              for_each = lookup(trigger.value, "slow_request", null) != null ? [lookup(trigger.value, "slow_request")] : []
              content {
                count      = slow_requests.value.count
                interval   = slow_requests.value.interval
                time_taken = slow_requests.value.time_taken
              }
            }
            dynamic "slow_request_with_path" {
              for_each = lookup(trigger.value, "slow_request_with_path", null) != null ? [lookup(trigger.value, "slow_request_with_path")] : []
              content {
                count      = slow_requests.value.count
                interval   = slow_requests.value.interval
                time_taken = slow_requests.value.time_taken
                path       = try(slow_requests.value.path, null)
              }
            }
            dynamic "status_code" {
              for_each = lookup(trigger.value, "status_code", null) != null ? [lookup(trigger.value, "status_code")] : []
              content {
                count             = status_code.value.count
                interval          = status_code.value.interval
                status_code_range = status_code.value.status_code_range
                path              = try(status_code.value.path, null)
                sub_status        = try(status_code.value.sub_status, null)
                win32_status_code = try(status_code.value.win32_status_code, null)
              }
            }
          }
        }
      }
    }

    dynamic "cors" {
      for_each = lookup(each.value.site_config, "cors", null) != null ? [lookup(each.value.site_config, "cors")] : []
      content {
        allowed_origins     = try(cors.value.allowed_origins, null)
        support_credentials = try(cors.value.support_credentials, false)
      }
    }

    dynamic "ip_restriction" {
      for_each = {
        for key, ip_restriction in lookup(each.value.site_config, "ip_restrictions", []) : key => ip_restriction
      }
      content {
        name                      = try(ip_restriction.value.name, each.key)
        action                    = try(ip_restriction.value.action, "Allow")
        ip_address                = try(ip_restriction.value.ip_address, null)
        priority                  = try(ip_restriction.value.priority, 65000)
        service_tag               = try(ip_restriction.value.service_tag, null)
        virtual_network_subnet_id = try(ip_restriction.value.virtual_network_subnet_id, null)
        description               = try(ip_restriction.value.description, null)

        dynamic "headers" {
          for_each = lookup(ip_restriction.value, "headers", null) != null ? [lookup(ip_restriction.value, "headers")] : []
          content {
            x_azure_fdid      = try(headers.value.x_azure_fdid, [])
            x_fd_health_probe = try(headers.value.x_fd_health_probe, null)
            x_forwarded_for   = try(headers.value.x_forwarded_for, [])
            x_forwarded_host  = try(headers.value.x_forwarded_host, [])
          }
        }
      }
    }

    dynamic "scm_ip_restriction" {
      for_each = {
        for key, ip_restriction in lookup(each.value.site_config, "scm_ip_restrictions", []) : key => ip_restriction
      }
      content {
        action                    = try(scm_ip_restriction.value.action, "Allow")
        ip_address                = try(scm_ip_restriction.value.ip_address, null)
        name                      = try(scm_ip_restriction.value.name, null)
        priority                  = try(scm_ip_restriction.value.priority, 65000)
        service_tag               = try(scm_ip_restriction.value.service_tag, null)
        virtual_network_subnet_id = try(scm_ip_restriction.value.virtual_network_subnet_id, null)
        description               = try(scm_ip_restriction.value.description, null)

        dynamic "headers" {
          for_each = lookup(scm_ip_restriction.value, "headers", null) != null ? [lookup(scm_ip_restriction.value, "headers")] : []
          content {
            x_azure_fdid      = try(headers.value.x_azure_fdid, [])
            x_fd_health_probe = try(headers.value.x_fd_health_probe, null)
            x_forwarded_for   = try(headers.value.x_forwarded_for, [])
            x_forwarded_host  = try(headers.value.x_forwarded_host, [])
          }
        }
      }
    }
  }

  dynamic "auth_settings" {
    for_each = try(var.instance.auth_settings, null) != null ? { default = var.instance.auth_settings } : {}
    content {
      enabled                        = auth_settings.value.enabled
      additional_login_parameters    = try(auth_settings.value.additional_login_parameters, null)
      allowed_external_redirect_urls = try(auth_settings.value.allowed_external_redirect_urls, null)
      default_provider               = try(auth_settings.value.default_provider, null)
      issuer                         = try(auth_settings.value.issuer, null)
      runtime_version                = try(auth_settings.value.runtime_version, null)
      token_refresh_extension_hours  = try(auth_settings.value.token_refresh_extension_hours, 72)
      token_store_enabled            = try(auth_settings.value.token_store_enabled, false)
      unauthenticated_client_action  = try(auth_settings.value.unauthenticated_client_action, null)

      dynamic "active_directory" {
        for_each = lookup(auth_settings.value, "active_directory", null) != null ? [lookup(auth_settings.value, "active_directory")] : []

        content {
          client_id                  = active_directory.value.client_id
          allowed_audiences          = active_directory.value.allowed_audiences
          client_secret              = try(active_directory.value.client_secret, null)
          client_secret_setting_name = try(active_directory.value.client_secret_setting_name, null)
        }
      }

      dynamic "facebook" {
        for_each = lookup(auth_settings.value, "facebook", null) != null ? [lookup(auth_settings.value, "facebook")] : []
        content {
          app_id                  = facebook.value.app_id
          app_secret              = try(facebook.value.app_secret, null)
          app_secret_setting_name = try(facebook.value.app_secret_setting_name, null)
          oauth_scopes            = try(facebook.value.oauth_scopes, null)
        }
      }

      dynamic "github" {
        for_each = lookup(auth_settings.value, "github", null) != null ? [lookup(auth_settings.value, "github")] : []
        content {
          client_id                  = github.value.client_id
          client_secret              = try(github.value.client_secret, null)
          client_secret_setting_name = try(github.value.client_secret_setting_name, null)
          oauth_scopes               = try(github.value.oauth_scopes, null)
        }
      }

      dynamic "google" {
        for_each = lookup(auth_settings.value, "google", null) != null ? [lookup(auth_settings.value, "google")] : []
        content {
          client_id                  = google.value.client_id
          client_secret              = try(google.value.client_secret, null)
          client_secret_setting_name = try(google.value.client_secret_setting_name, null)
          oauth_scopes               = try(google.value.oauth_scopes, null)
        }
      }

      dynamic "microsoft" {
        for_each = lookup(auth_settings.value, "microsoft", null) != null ? [lookup(auth_settings.value, "microsoft")] : []
        content {
          client_id                  = microsoft.value.client_id
          client_secret              = try(microsoft.value.client_secret, null)
          client_secret_setting_name = try(microsoft.value.client_secret_setting_name, null)
          oauth_scopes               = try(microsoft.value.oauth_scopes, null)
        }
      }

      dynamic "twitter" {
        for_each = lookup(auth_settings.value, "twitter", null) != null ? [lookup(auth_settings.value, "twitter")] : []
        content {
          consumer_key                 = twitter.value.consumer_key
          consumer_secret              = try(twitter.value.consumer_secret, null)
          consumer_secret_setting_name = try(twitter.value.consumer_secret_setting_name, null)
        }
      }
    }
  }

  dynamic "auth_settings_v2" {
    for_each = try(var.instance.auth_settings_v2, null) != null ? { default = var.instance.auth_settings_v2 } : {}
    content {
      auth_enabled                            = try(auth_settings_v2.value.auth_enabled, null)
      runtime_version                         = try(auth_settings_v2.value.runtime_version, "~1")
      config_file_path                        = try(auth_settings_v2.value.config_file_path, null)
      require_authentication                  = try(auth_settings_v2.value.require_authentication, null)
      unauthenticated_action                  = try(auth_settings_v2.value.unauthenticated_action, null)
      default_provider                        = try(auth_settings_v2.value.default_provider, null)
      excluded_paths                          = try(auth_settings_v2.value.excluded_paths, null)
      require_https                           = try(auth_settings_v2.value.require_https, true)
      http_route_api_prefix                   = try(auth_settings_v2.value.http_route_api_prefix, "/.auth")
      forward_proxy_convention                = try(auth_settings_v2.value.forward_proxy_convention, "NoProxy")
      forward_proxy_custom_host_header_name   = try(auth_settings_v2.value.forward_proxy_custom_host_header_name, null)
      forward_proxy_custom_scheme_header_name = try(auth_settings_v2.value.forward_proxy_custom_scheme_header_name, null)

      dynamic "login" {
        for_each = lookup(auth_settings_v2.value, "login", null) != null ? [lookup(auth_settings_v2.value, "login")] : []
        content {
          logout_endpoint                   = try(login.value.logout_endpoint, null)
          token_store_enabled               = try(login.value.token_store_enabled, false)
          token_refresh_extension_time      = try(login.value.token_refresh_extension_time, 72)
          token_store_path                  = try(login.value.token_store_path, null)
          token_store_sas_setting_name      = try(login.value.token_store_sas_setting_name, null)
          preserve_url_fragments_for_logins = try(login.value.preserve_url_fragments_for_logins, false)
          allowed_external_redirect_urls    = try(login.value.allowed_external_redirect_urls, [])
          cookie_expiration_convention      = try(login.value.cookie_expiration_convention, "FixedTime")
          cookie_expiration_time            = try(login.value.cookie_expiration_time, "08:00:00")
          validate_nonce                    = try(login.value.validate_nonce, true)
          nonce_expiration_time             = try(login.value.nonce_expiration_time, "00:05:00")
        }
      }

      dynamic "apple_v2" {
        for_each = lookup(auth_settings_v2.value, "apple_v2", null) != null ? [lookup(auth_settings_v2.value, "apple_v2")] : []
        content {
          client_id                  = apple_v2.value.client_id
          client_secret_setting_name = apple_v2.value.client_secret_setting_name
          login_scopes               = apple_v2.value.login_scopes

        }
      }

      dynamic "active_directory_v2" {
        for_each = lookup(auth_settings_v2.value, "active_directory_v2", null) != null ? [lookup(auth_settings_v2.value, "active_directory_v2")] : []
        content {
          client_id                            = active_directory_v2.value.client_id
          tenant_auth_endpoint                 = active_directory_v2.value.tenant_auth_endpoint
          client_secret_setting_name           = try(active_directory_v2.value.client_secret_setting_name, null)
          client_secret_certificate_thumbprint = try(active_directory_v2.value.client_secret_certificate_thumbprint, null)
          jwt_allowed_groups                   = try(active_directory_v2.value.jwt_allowed_groups, [])
          jwt_allowed_client_applications      = try(active_directory_v2.value.jwt_allowed_client_applications, [])
          www_authentication_disabled          = try(active_directory_v2.value.www_authentication_disabled, false)
          allowed_applications                 = try(active_directory_v2.value.allowed_applications, [])
          allowed_audiences                    = try(active_directory_v2.value.allowed_audiences, [])
          allowed_groups                       = try(active_directory_v2.value.allowed_groups, [])
          allowed_identities                   = try(active_directory_v2.value.allowed_identities, [])
        }
      }

      dynamic "azure_static_web_app_v2" {
        for_each = lookup(auth_settings_v2.value, "azure_static_web_app_v2", null) != null ? [lookup(auth_settings_v2.value, "azure_static_web_app_v2")] : []
        content {
          client_id = azure_static_web_app_v2.value.client_id
        }
      }

      dynamic "custom_oidc_v2" {
        for_each = lookup(auth_settings_v2.value, "custom_oidc_v2", null) != null ? [lookup(auth_settings_v2.value, "custom_oidc_v2")] : []
        content {
          name                          = custom_oidc_v2.value.name
          client_id                     = custom_oidc_v2.value.client_id
          openid_configuration_endpoint = custom_oidc_v2.value.openid_configuration_endpoint
          name_claim_type               = try(custom_oidc_v2.value.name_clame_type, null)
          scopes                        = try(custom_oidc_v2.value.scopes, [])
          client_credential_method      = try(custom_oidc_v2.value.client_credential_method, null)
          client_secret_setting_name    = try(custom_oidc_v2.value.client_secret_setting_name, "${custom_oidc_v2.value.name}_PROVIDER_AUTHENTICATION_SECRET")
          authorisation_endpoint        = try(custom_oidc_v2.value.authorisation_endpoint, null)
          token_endpoint                = try(custom_oidc_v2.value.token_endpoint, null)
          issuer_endpoint               = try(custom_oidc_v2.value.issuer_endpoint, null)
          certification_uri             = try(custom_oidc_v2.value.certification_uri, null)
        }
      }

      dynamic "facebook_v2" {
        for_each = lookup(auth_settings_v2.value, "facebook_v2", null) != null ? [lookup(auth_settings_v2.value, "facebook_v2")] : []
        content {
          app_id                  = facebook_v2.value.app_id
          app_secret_setting_name = facebook_v2.value.app_secret_setting_name
          graph_api_version       = try(facebook_v2.value.graph_api_version, null)
          login_scopes            = try(facebook_v2.value.login_scopes, [])
        }
      }

      dynamic "github_v2" {
        for_each = lookup(auth_settings_v2.value, "github_v2", null) != null ? [lookup(auth_settings_v2.value, "github_v2")] : []
        content {
          client_id                  = github_v2.value.client_id
          client_secret_setting_name = github_v2.value.client_secret_setting_name
          login_scopes               = try(github_v2.value.login_scopes, [])
        }
      }

      dynamic "google_v2" {
        for_each = lookup(auth_settings_v2.value, "google_v2", null) != null ? [lookup(auth_settings_v2.value, "google_v2")] : []
        content {
          client_id                  = google_v2.value.client_id
          client_secret_setting_name = google_v2.value.client_secret_setting_name
          allowed_audiences          = try(google_v2.value.allowed_audiences, [])
          login_scopes               = try(google_v2.value.login_scopes, [])
        }
      }

      dynamic "microsoft_v2" {
        for_each = lookup(auth_settings_v2.value, "microsoft_v2", null) != null ? [lookup(auth_settings_v2.value, "microsoft_v2")] : []
        content {
          client_id                  = microsoft_v2.value.client_id
          client_secret_setting_name = microsoft_v2.value.client_secret_setting_name
          allowed_audiences          = try(microsoft_v2.value.allowed_audiences, [])
          login_scopes               = try(microsoft_v2.value.login_scopes, [])
        }
      }

      dynamic "twitter_v2" {
        for_each = lookup(auth_settings_v2.value, "twitter_v2", null) != null ? [lookup(auth_settings_v2.value, "twitter_v2")] : []
        content {
          consumer_key                 = twitter_v2.value.consumer_key
          consumer_secret_setting_name = twitter_v2.value.consumer_secret_setting_name
        }
      }
    }
  }

  dynamic "backup" {
    for_each = try(var.instance.backup, null) != null ? { default = var.instance.backup } : {}
    content {
      enabled             = try(backup.value.enabled, true)
      name                = backup.value.name
      storage_account_url = backup.value.storage_account_url

      dynamic "schedule" {
        for_each = lookup(backup.value, "schedule", null) != null ? [lookup(backup.value, "schedule")] : []
        content {
          frequency_interval       = schedule.value.frequency_interval
          frequency_unit           = schedule.value.frequency_unit
          keep_at_least_one_backup = try(schedule.value.keep_at_least_one_backup, false)
          retention_period_days    = try(schedule.value.retention_period_days, 30)
          start_time               = try(schedule.value.start_time, null)
        }
      }
    }
  }

  dynamic "connection_string" {
    for_each = try(var.instance.connection_string, null) != null ? { default = var.instance.connection_string } : {}
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  dynamic "identity" {
    for_each = [lookup(var.instance, "identity", { type = "SystemAssigned", identity_ids = [] })]

    content {
      type = identity.value.type
      identity_ids = concat(
        try([azurerm_user_assigned_identity.identity["identity"].id], []),
        lookup(identity.value, "identity_ids", [])
      )
    }
  }

  dynamic "logs" {
    for_each = try(var.instance.logs, null) != null ? { default = var.instance.logs } : {}
    content {
      detailed_error_messages = try(logs.value.detailed_error_messages, null)
      failed_request_tracing  = try(logs.value.failed_request_tracing, null)

      dynamic "application_logs" {
        for_each = lookup(logs.value, "application_logs", null) != null ? [lookup(logs.value, "application_logs")] : []
        content {
          file_system_level = application_logs.value.file_system_level
          dynamic "azure_blob_storage" {
            for_each = lookup(each.value.application_logs, "azure_blob_storage", null) != null ? [lookup(each.value.application_logs, "azure_blob_storage")] : []
            content {
              level             = azure_blob_storage.value.level
              sas_url           = azure_blob_storage.value.sas_url
              retention_in_days = try(azure_blob_storage.value.retention_in_days, 0)
            }
          }
        }
      }

      dynamic "http_logs" {
        for_each = lookup(each.value.logs, "http_logs", null) != null ? [lookup(each.value.logs, "http_logs")] : []
        content {
          dynamic "azure_blob_storage" {
            for_each = lookup(http_logs.value, "azure_blob_storage", null) != null ? [lookup(http_logs.value, "azure_blob_storage")] : []
            content {
              sas_url           = azure_blob_storage.value.sas_url
              retention_in_days = try(azure_blob_storage.value.retention_in_days, 0)
            }
          }
          dynamic "file_system" {
            for_each = lookup(http_logs.value, "file_system", null) != null ? [lookup(http_logs.value, "file_system")] : []
            content {
              retention_in_days = try(file_system.value.retention_in_days, 0)
              retention_in_mb   = file_system.value.retention_in_mb
            }
          }
        }
      }
    }
  }

  dynamic "storage_account" {
    for_each = try(var.instance.storage_account, null) != null ? { default = var.instance.storage_account } : {}
    content {
      access_key   = storage_account.value.access_key
      account_name = storage_account.value.account_name
      name         = storage_account.value.name
      share_name   = storage_account.value.share_name
      type         = storage_account.value.type
      mount_path   = try(storage_account.value.mount_path, null)
    }
  }
}

# windows web app
resource "azurerm_windows_web_app" "windows" {
  for_each = var.instance.type == "windows" ? {
    (var.instance.name) = var.instance
  } : {}

  name                                           = var.instance.name
  location                                       = coalesce(lookup(var.instance, "location", null), var.location)
  resource_group_name                            = coalesce(lookup(var.instance, "resource_group", null), var.resource_group)
  service_plan_id                                = var.instance.service_plan_id
  app_settings                                   = {}
  client_affinity_enabled                        = try(var.instance.client_affinity_enabled, null)
  client_certificate_enabled                     = try(var.instance.client_certificate_enabled, null)
  client_certificate_mode                        = try(var.instance.client_certificate_mode, "Required")
  client_certificate_exclusion_paths             = try(var.instance.client_certificate_exclusion_paths, null)
  enabled                                        = try(var.instance.enabled, true)
  ftp_publish_basic_authentication_enabled       = try(var.instance.ftp_publish_basic_authentication_enabled, true)
  https_only                                     = try(var.instance.https_only, false)
  public_network_access_enabled                  = try(var.instance.public_network_access_enabled, true)
  key_vault_reference_identity_id                = try(var.instance.key_vault_reference_identity_id, null)
  virtual_network_subnet_id                      = try(var.instance.virtual_network_subnet_id, null)
  webdeploy_publish_basic_authentication_enabled = try(var.instance.webdeploy_publish_basic_authentication_enabled, true)
  zip_deploy_file                                = try(var.instance.zip_deploy_file, null)
  tags                                           = try(var.instance.tags, var.tags, {})

  # block
  site_config {
    always_on                                     = try(var.instance.site_config.always_on, true)
    api_definition_url                            = try(var.instance.site_config.api_definition_url, null)
    api_management_api_id                         = try(var.instance.site_config.api_management_api_id, null)
    app_command_line                              = try(var.instance.site_config.app_command_line, null)
    container_registry_managed_identity_client_id = try(var.instance.site_config.container_registry_managed_identity_client_id, null)
    container_registry_use_managed_identity       = try(var.instance.site_config.container_registry_use_managed_identity, null)
    default_documents                             = try(var.instance.site_config.default_documents, null)
    ftps_state                                    = try(var.instance.site_config.ftps_state, "Disabled")
    health_check_path                             = try(var.instance.site_config.health_check_path, null)
    health_check_eviction_time_in_min             = try(var.instance.site_config.health_check_eviction_time_in_min, null)
    http2_enabled                                 = try(var.instance.site_config.http2_enabled, null)
    ip_restriction_default_action                 = try(var.instance.site_config.ip_restriction_default_action, null)
    load_balancing_mode                           = try(var.instance.site_config.load_balancing_mode, null)
    local_mysql_enabled                           = try(var.instance.site_config.local_mysql_enabled, false)
    managed_pipeline_mode                         = try(var.instance.site_config.managed_pipeline_mode, "Integrated")
    minimum_tls_version                           = try(var.instance.site_config.minimum_tls_version, "1.2")
    remote_debugging_enabled                      = try(var.instance.site_config.remote_debugging_enabled, false)
    scm_ip_restriction_default_action             = try(var.instance.site_config.scm_ip_restriction_default_action, "Allow")
    scm_use_main_ip_restriction                   = try(var.instance.site_config.scm_use_main_ip_restriction, null)
    use_32_bit_worker                             = try(var.instance.site_config.use_32_bit_worker, true)
    vnet_route_all_enabled                        = try(var.instance.site_config.vnet_route_all_enabled, false)
    websockets_enabled                            = try(var.instance.site_config.websockets_enabled, false)
    worker_count                                  = try(var.instance.site_config.worker_count, null)

    dynamic "application_stack" {
      for_each = lookup(each.value.site_config, "application_stack", null) != null ? [lookup(each.value.site_config, "application_stack")] : []

      content {
        current_stack                = try(application_stack.value.current_stack, null)
        docker_image_name            = try(application_stack.value.docker_image_name, null)
        docker_registry_url          = try(application_stack.value.docker_registry_url, null)
        docker_registry_username     = try(application_stack.value.docker_registry_username, null)
        docker_registry_password     = try(application_stack.value.docker_registry_password, null)
        dotnet_version               = try(application_stack.value.dotnet_version, null)
        dotnet_core_version          = try(application_stack.value.dotnet_core_version, null)
        tomcat_version               = try(application_stack.value.tomcat_version, null)
        java_embedded_server_enabled = try(application_stack.value.java_embedded_server_enabled, null)
        java_version                 = try(application_stack.value.java_version, null)
        node_version                 = try(application_stack.value.node_version, null)
        php_version                  = try(application_stack.value.php_version, null)
        python                       = try(application_stack.value.python, false)
      }
    }

    dynamic "auto_heal_setting" {
      for_each = lookup(each.value.site_config, "auto_heal_setting", null) != null ? [lookup(each.value.site_config, "auto_heal_setting")] : []

      content {
        dynamic "action" {
          for_each = lookup(auto_heal_setting.value, "action", null) != null ? [lookup(auto_heal_setting.value, "action")] : []
          content {
            action_type                    = action.value.action_type
            minimum_process_execution_time = try(action.value.minimum_process_execution_time, null)
          }
        }

        dynamic "trigger" {
          for_each = lookup(auto_heal_setting.value, "trigger", null) != null ? [lookup(auto_heal_setting.value, "trigger")] : []
          content {
            dynamic "requests" {
              for_each = lookup(trigger.value, "requests", null) != null ? [lookup(trigger.value, "requests")] : []
              content {
                count    = requests.value.count
                interval = requests.value.interval
              }
            }
            dynamic "slow_request" {
              for_each = lookup(trigger.value, "slow_request", null) != null ? [lookup(trigger.value, "slow_request")] : []
              content {
                count      = slow_requests.value.count
                interval   = slow_requests.value.interval
                time_taken = slow_requests.value.time_taken
              }
            }
            dynamic "slow_request_with_path" {
              for_each = lookup(trigger.value, "slow_request_with_path", null) != null ? [lookup(trigger.value, "slow_request_with_path")] : []
              content {
                count      = slow_requests.value.count
                interval   = slow_requests.value.interval
                time_taken = slow_requests.value.time_taken
                path       = try(slow_requests.value.path, null)
              }
            }
            dynamic "status_code" {
              for_each = lookup(trigger.value, "status_code", null) != null ? [lookup(trigger.value, "status_code")] : []
              content {
                count             = status_code.value.count
                interval          = status_code.value.interval
                status_code_range = status_code.value.status_code_range
                path              = try(status_code.value.path, null)
                sub_status        = try(status_code.value.sub_status, null)
                win32_status_code = try(status_code.value.win32_status_code, null)
              }
            }
          }
        }
      }
    }

    dynamic "cors" {
      for_each = lookup(each.value.site_config, "cors", null) != null ? [lookup(each.value.site_config, "cors")] : []
      content {
        allowed_origins     = try(cors.value.allowed_origins, null)
        support_credentials = try(cors.value.support_credentials, false)
      }
    }

    dynamic "ip_restriction" {
      for_each = {
        for key, ip_restriction in lookup(each.value.site_config, "ip_restrictions", []) : key => ip_restriction
      }
      content {
        name                      = try(ip_restriction.value.name, each.key)
        action                    = try(ip_restriction.value.action, "Allow")
        ip_address                = try(ip_restriction.value.ip_address, null)
        priority                  = try(ip_restriction.value.priority, 65000)
        service_tag               = try(ip_restriction.value.service_tag, null)
        virtual_network_subnet_id = try(ip_restriction.value.virtual_network_subnet_id, null)
        description               = try(ip_restriction.value.description, null)

        dynamic "headers" {
          for_each = lookup(ip_restriction.value, "headers", null) != null ? [lookup(ip_restriction.value, "headers")] : []
          content {
            x_azure_fdid      = try(headers.value.x_azure_fdid, [])
            x_fd_health_probe = try(headers.value.x_fd_health_probe, null)
            x_forwarded_for   = try(headers.value.x_forwarded_for, [])
            x_forwarded_host  = try(headers.value.x_forwarded_host, [])
          }
        }
      }
    }

    dynamic "scm_ip_restriction" {
      for_each = {
        for key, ip_restriction in lookup(each.value.site_config, "scm_ip_restrictions", []) : key => ip_restriction
      }
      content {
        action                    = try(scm_ip_restriction.value.action, "Allow")
        ip_address                = try(scm_ip_restriction.value.ip_address, null)
        name                      = try(scm_ip_restriction.value.name, null)
        priority                  = try(scm_ip_restriction.value.priority, 65000)
        service_tag               = try(scm_ip_restriction.value.service_tag, null)
        virtual_network_subnet_id = try(scm_ip_restriction.value.virtual_network_subnet_id, null)
        description               = try(scm_ip_restriction.value.description, null)

        dynamic "headers" {
          for_each = lookup(scm_ip_restriction.value, "headers", null) != null ? [lookup(scm_ip_restriction.value, "headers")] : []
          content {
            x_azure_fdid      = try(headers.value.x_azure_fdid, [])
            x_fd_health_probe = try(headers.value.x_fd_health_probe, null)
            x_forwarded_for   = try(headers.value.x_forwarded_for, [])
            x_forwarded_host  = try(headers.value.x_forwarded_host, [])
          }
        }
      }
    }
  }

  dynamic "auth_settings" {
    for_each = try(var.instance.auth_settings, null) != null ? { default = var.instance.auth_settings } : {}
    content {
      enabled                        = auth_settings.value.enabled
      additional_login_parameters    = try(auth_settings.value.additional_login_parameters, null)
      allowed_external_redirect_urls = try(auth_settings.value.allowed_external_redirect_urls, null)
      default_provider               = try(auth_settings.value.default_provider, null)
      issuer                         = try(auth_settings.value.issuer, null)
      runtime_version                = try(auth_settings.value.runtime_version, null)
      token_refresh_extension_hours  = try(auth_settings.value.token_refresh_extension_hours, 72)
      token_store_enabled            = try(auth_settings.value.token_store_enabled, false)
      unauthenticated_client_action  = try(auth_settings.value.unauthenticated_client_action, null)

      dynamic "active_directory" {
        for_each = lookup(auth_settings.value, "active_directory", null) != null ? [lookup(auth_settings.value, "active_directory")] : []

        content {
          client_id                  = active_directory.value.client_id
          allowed_audiences          = active_directory.value.allowed_audiences
          client_secret              = try(active_directory.value.client_secret, null)
          client_secret_setting_name = try(active_directory.value.client_secret_setting_name, null)
        }
      }

      dynamic "facebook" {
        for_each = lookup(auth_settings.value, "facebook", null) != null ? [lookup(auth_settings.value, "facebook")] : []
        content {
          app_id                  = facebook.value.app_id
          app_secret              = try(facebook.value.app_secret, null)
          app_secret_setting_name = try(facebook.value.app_secret_setting_name, null)
          oauth_scopes            = try(facebook.value.oauth_scopes, null)
        }
      }

      dynamic "github" {
        for_each = lookup(auth_settings.value, "github", null) != null ? [lookup(auth_settings.value, "github")] : []
        content {
          client_id                  = github.value.client_id
          client_secret              = try(github.value.client_secret, null)
          client_secret_setting_name = try(github.value.client_secret_setting_name, null)
          oauth_scopes               = try(github.value.oauth_scopes, null)
        }
      }

      dynamic "google" {
        for_each = lookup(auth_settings.value, "google", null) != null ? [lookup(auth_settings.value, "google")] : []
        content {
          client_id                  = google.value.client_id
          client_secret              = try(google.value.client_secret, null)
          client_secret_setting_name = try(google.value.client_secret_setting_name, null)
          oauth_scopes               = try(google.value.oauth_scopes, null)
        }
      }

      dynamic "microsoft" {
        for_each = lookup(auth_settings.value, "microsoft", null) != null ? [lookup(auth_settings.value, "microsoft")] : []
        content {
          client_id                  = microsoft.value.client_id
          client_secret              = try(microsoft.value.client_secret, null)
          client_secret_setting_name = try(microsoft.value.client_secret_setting_name, null)
          oauth_scopes               = try(microsoft.value.oauth_scopes, null)
        }
      }

      dynamic "twitter" {
        for_each = lookup(auth_settings.value, "twitter", null) != null ? [lookup(auth_settings.value, "twitter")] : []
        content {
          consumer_key                 = twitter.value.consumer_key
          consumer_secret              = try(twitter.value.consumer_secret, null)
          consumer_secret_setting_name = try(twitter.value.consumer_secret_setting_name, null)
        }
      }
    }
  }

  dynamic "auth_settings_v2" {
    for_each = try(var.instance.auth_settings_v2, null) != null ? { default = var.instance.auth_settings_v2 } : {}
    content {
      auth_enabled                            = try(auth_settings_v2.value.auth_enabled, null)
      runtime_version                         = try(auth_settings_v2.value.runtime_version, "~1")
      config_file_path                        = try(auth_settings_v2.value.config_file_path, null)
      require_authentication                  = try(auth_settings_v2.value.require_authentication, null)
      unauthenticated_action                  = try(auth_settings_v2.value.unauthenticated_action, null)
      default_provider                        = try(auth_settings_v2.value.default_provider, null)
      excluded_paths                          = try(auth_settings_v2.value.excluded_paths, null)
      require_https                           = try(auth_settings_v2.value.require_https, true)
      http_route_api_prefix                   = try(auth_settings_v2.value.http_route_api_prefix, "/.auth")
      forward_proxy_convention                = try(auth_settings_v2.value.forward_proxy_convention, "NoProxy")
      forward_proxy_custom_host_header_name   = try(auth_settings_v2.value.forward_proxy_custom_host_header_name, null)
      forward_proxy_custom_scheme_header_name = try(auth_settings_v2.value.forward_proxy_custom_scheme_header_name, null)

      dynamic "login" {
        for_each = lookup(auth_settings_v2.value, "login", null) != null ? [lookup(auth_settings_v2.value, "login")] : []
        content {
          logout_endpoint                   = try(login.value.logout_endpoint, null)
          token_store_enabled               = try(login.value.token_store_enabled, false)
          token_refresh_extension_time      = try(login.value.token_refresh_extension_time, 72)
          token_store_path                  = try(login.value.token_store_path, null)
          token_store_sas_setting_name      = try(login.value.token_store_sas_setting_name, null)
          preserve_url_fragments_for_logins = try(login.value.preserve_url_fragments_for_logins, false)
          allowed_external_redirect_urls    = try(login.value.allowed_external_redirect_urls, [])
          cookie_expiration_convention      = try(login.value.cookie_expiration_convention, "FixedTime")
          cookie_expiration_time            = try(login.value.cookie_expiration_time, "08:00:00")
          validate_nonce                    = try(login.value.validate_nonce, true)
          nonce_expiration_time             = try(login.value.nonce_expiration_time, "00:05:00")
        }
      }

      dynamic "apple_v2" {
        for_each = lookup(auth_settings_v2.value, "apple_v2", null) != null ? [lookup(auth_settings_v2.value, "apple_v2")] : []
        content {
          client_id                  = apple_v2.value.client_id
          client_secret_setting_name = apple_v2.value.client_secret_setting_name
          login_scopes               = apple_v2.value.login_scopes

        }
      }

      dynamic "active_directory_v2" {
        for_each = lookup(auth_settings_v2.value, "active_directory_v2", null) != null ? [lookup(auth_settings_v2.value, "active_directory_v2")] : []
        content {
          client_id                            = active_directory_v2.value.client_id
          tenant_auth_endpoint                 = active_directory_v2.value.tenant_auth_endpoint
          client_secret_setting_name           = try(active_directory_v2.value.client_secret_setting_name, null)
          client_secret_certificate_thumbprint = try(active_directory_v2.value.client_secret_certificate_thumbprint, null)
          jwt_allowed_groups                   = try(active_directory_v2.value.jwt_allowed_groups, [])
          jwt_allowed_client_applications      = try(active_directory_v2.value.jwt_allowed_client_applications, [])
          www_authentication_disabled          = try(active_directory_v2.value.www_authentication_disabled, false)
          allowed_applications                 = try(active_directory_v2.value.allowed_applications, [])
          allowed_audiences                    = try(active_directory_v2.value.allowed_audiences, [])
          allowed_groups                       = try(active_directory_v2.value.allowed_groups, [])
          allowed_identities                   = try(active_directory_v2.value.allowed_identities, [])
        }
      }

      dynamic "azure_static_web_app_v2" {
        for_each = lookup(auth_settings_v2.value, "azure_static_web_app_v2", null) != null ? [lookup(auth_settings_v2.value, "azure_static_web_app_v2")] : []
        content {
          client_id = azure_static_web_app_v2.value.client_id
        }
      }

      dynamic "custom_oidc_v2" {
        for_each = lookup(auth_settings_v2.value, "custom_oidc_v2", null) != null ? [lookup(auth_settings_v2.value, "custom_oidc_v2")] : []
        content {
          name                          = custom_oidc_v2.value.name
          client_id                     = custom_oidc_v2.value.client_id
          openid_configuration_endpoint = custom_oidc_v2.value.openid_configuration_endpoint
          name_claim_type               = try(custom_oidc_v2.value.name_clame_type, null)
          scopes                        = try(custom_oidc_v2.value.scopes, [])
          client_credential_method      = try(custom_oidc_v2.value.client_credential_method, null)
          client_secret_setting_name    = try(custom_oidc_v2.value.client_secret_setting_name, "${custom_oidc_v2.value.name}_PROVIDER_AUTHENTICATION_SECRET")
          authorisation_endpoint        = try(custom_oidc_v2.value.authorisation_endpoint, null)
          token_endpoint                = try(custom_oidc_v2.value.token_endpoint, null)
          issuer_endpoint               = try(custom_oidc_v2.value.issuer_endpoint, null)
          certification_uri             = try(custom_oidc_v2.value.certification_uri, null)
        }
      }

      dynamic "facebook_v2" {
        for_each = lookup(auth_settings_v2.value, "facebook_v2", null) != null ? [lookup(auth_settings_v2.value, "facebook_v2")] : []
        content {
          app_id                  = facebook_v2.value.app_id
          app_secret_setting_name = facebook_v2.value.app_secret_setting_name
          graph_api_version       = try(facebook_v2.value.graph_api_version, null)
          login_scopes            = try(facebook_v2.value.login_scopes, [])
        }
      }

      dynamic "github_v2" {
        for_each = lookup(auth_settings_v2.value, "github_v2", null) != null ? [lookup(auth_settings_v2.value, "github_v2")] : []
        content {
          client_id                  = github_v2.value.client_id
          client_secret_setting_name = github_v2.value.client_secret_setting_name
          login_scopes               = try(github_v2.value.login_scopes, [])
        }
      }

      dynamic "google_v2" {
        for_each = lookup(auth_settings_v2.value, "google_v2", null) != null ? [lookup(auth_settings_v2.value, "google_v2")] : []
        content {
          client_id                  = google_v2.value.client_id
          client_secret_setting_name = google_v2.value.client_secret_setting_name
          allowed_audiences          = try(google_v2.value.allowed_audiences, [])
          login_scopes               = try(google_v2.value.login_scopes, [])
        }
      }

      dynamic "microsoft_v2" {
        for_each = lookup(auth_settings_v2.value, "microsoft_v2", null) != null ? [lookup(auth_settings_v2.value, "microsoft_v2")] : []
        content {
          client_id                  = microsoft_v2.value.client_id
          client_secret_setting_name = microsoft_v2.value.client_secret_setting_name
          allowed_audiences          = try(microsoft_v2.value.allowed_audiences, [])
          login_scopes               = try(microsoft_v2.value.login_scopes, [])
        }
      }

      dynamic "twitter_v2" {
        for_each = lookup(auth_settings_v2.value, "twitter_v2", null) != null ? [lookup(auth_settings_v2.value, "twitter_v2")] : []
        content {
          consumer_key                 = twitter_v2.value.consumer_key
          consumer_secret_setting_name = twitter_v2.value.consumer_secret_setting_name
        }
      }
    }
  }

  dynamic "backup" {
    for_each = try(var.instance.backup, null) != null ? { default = var.instance.backup } : {}
    content {
      enabled             = try(backup.value.enabled, true)
      name                = backup.value.name
      storage_account_url = backup.value.storage_account_url

      dynamic "schedule" {
        for_each = lookup(backup.value, "schedule", null) != null ? [lookup(backup.value, "schedule")] : []
        content {
          frequency_interval       = schedule.value.frequency_interval
          frequency_unit           = schedule.value.frequency_unit
          keep_at_least_one_backup = try(schedule.value.keep_at_least_one_backup, false)
          retention_period_days    = try(schedule.value.retention_period_days, 30)
          start_time               = try(schedule.value.start_time, null)
        }
      }
    }
  }

  dynamic "connection_string" {
    for_each = try(var.instance.connection_string, null) != null ? { default = var.instance.connection_string } : {}
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  dynamic "identity" {
    for_each = [lookup(var.instance, "identity", { type = "SystemAssigned", identity_ids = [] })]

    content {
      type = identity.value.type
      identity_ids = concat(
        try([azurerm_user_assigned_identity.identity["identity"].id], []),
        lookup(identity.value, "identity_ids", [])
      )
    }
  }

  dynamic "logs" {
    for_each = try(var.instance.logs, null) != null ? { default = var.instance.logs } : {}
    content {
      detailed_error_messages = try(logs.value.detailed_error_messages, null)
      failed_request_tracing  = try(logs.value.failed_request_tracing, null)

      dynamic "application_logs" {
        for_each = lookup(logs.value, "application_logs", null) != null ? [lookup(logs.value, "application_logs")] : []
        content {
          file_system_level = application_logs.value.file_system_level
          dynamic "azure_blob_storage" {
            for_each = lookup(each.value.application_logs, "azure_blob_storage", null) != null ? [lookup(each.value.application_logs, "azure_blob_storage")] : []
            content {
              level             = azure_blob_storage.value.level
              sas_url           = azure_blob_storage.value.sas_url
              retention_in_days = try(azure_blob_storage.value.retention_in_days, 0)
            }
          }
        }
      }

      dynamic "http_logs" {
        for_each = lookup(each.value.logs, "http_logs", null) != null ? [lookup(each.value.logs, "http_logs")] : []
        content {
          dynamic "azure_blob_storage" {
            for_each = lookup(http_logs.value, "azure_blob_storage", null) != null ? [lookup(http_logs.value, "azure_blob_storage")] : []
            content {
              sas_url           = azure_blob_storage.value.sas_url
              retention_in_days = try(azure_blob_storage.value.retention_in_days, 0)
            }
          }
          dynamic "file_system" {
            for_each = lookup(http_logs.value, "file_system", null) != null ? [lookup(http_logs.value, "file_system")] : []
            content {
              retention_in_days = try(file_system.value.retention_in_days, 0)
              retention_in_mb   = file_system.value.retention_in_mb
            }
          }
        }
      }
    }
  }

  dynamic "storage_account" {
    for_each = try(var.instance.storage_account, null) != null ? { default = var.instance.storage_account } : {}
    content {
      access_key   = storage_account.value.access_key
      account_name = storage_account.value.account_name
      name         = storage_account.value.name
      share_name   = storage_account.value.share_name
      type         = storage_account.value.type
      mount_path   = try(storage_account.value.mount_path, null)
    }
  }

  dynamic "sticky_settings" {
    for_each = try(var.instance.sticky_settings, null) != null ? { default = var.instance.sticky_settings } : {}
    content {
      app_setting_names       = try(sticky_settings.value.app_setting_names, [])
      connection_string_names = try(sticky_settings.value.connection_string_names, [])
    }
  }
}

# windows web app slot
resource "azurerm_windows_web_app_slot" "windows" {
  for_each = {
    for key, value in try(var.instance.slots, {}) : key => value
    if var.instance.type == "windows"
  }

  name                                           = try(each.value.name, each.key)
  app_service_id                                 = azurerm_windows_web_app.windows[var.instance.name].id
  app_settings                                   = {}
  client_affinity_enabled                        = try(var.instance.client_affinity_enabled, null)
  client_certificate_enabled                     = try(var.instance.client_certificate_enabled, null)
  client_certificate_mode                        = try(var.instance.client_certificate_mode, "Required")
  client_certificate_exclusion_paths             = try(var.instance.client_certificate_exclusion_paths, null)
  enabled                                        = try(var.instance.enabled, true)
  ftp_publish_basic_authentication_enabled       = try(var.instance.ftp_publish_basic_authentication_enabled, true)
  https_only                                     = try(var.instance.https_only, false)
  public_network_access_enabled                  = try(var.instance.public_network_access_enabled, true)
  key_vault_reference_identity_id                = try(var.instance.key_vault_reference_identity_id, null)
  virtual_network_subnet_id                      = try(var.instance.virtual_network_subnet_id, null)
  webdeploy_publish_basic_authentication_enabled = try(var.instance.webdeploy_publish_basic_authentication_enabled, true)
  zip_deploy_file                                = try(var.instance.zip_deploy_file, null)
  tags                                           = try(var.instance.tags, var.tags, {})

  site_config {
    always_on                                     = try(var.instance.site_config.always_on, true)
    api_definition_url                            = try(var.instance.site_config.api_definition_url, null)
    api_management_api_id                         = try(var.instance.site_config.api_management_api_id, null)
    app_command_line                              = try(var.instance.site_config.app_command_line, null)
    container_registry_managed_identity_client_id = try(var.instance.site_config.container_registry_managed_identity_client_id, null)
    container_registry_use_managed_identity       = try(var.instance.site_config.container_registry_use_managed_identity, null)
    default_documents                             = try(var.instance.site_config.default_documents, null)
    ftps_state                                    = try(var.instance.site_config.ftps_state, "Disabled")
    health_check_path                             = try(var.instance.site_config.health_check_path, null)
    health_check_eviction_time_in_min             = try(var.instance.site_config.health_check_eviction_time_in_min, null)
    http2_enabled                                 = try(var.instance.site_config.http2_enabled, null)
    ip_restriction_default_action                 = try(var.instance.site_config.ip_restriction_default_action, null)
    load_balancing_mode                           = try(var.instance.site_config.load_balancing_mode, null)
    local_mysql_enabled                           = try(var.instance.site_config.local_mysql_enabled, false)
    managed_pipeline_mode                         = try(var.instance.site_config.managed_pipeline_mode, "Integrated")
    minimum_tls_version                           = try(var.instance.site_config.minimum_tls_version, "1.2")
    remote_debugging_enabled                      = try(var.instance.site_config.remote_debugging_enabled, false)
    scm_ip_restriction_default_action             = try(var.instance.site_config.scm_ip_restriction_default_action, "Allow")
    scm_use_main_ip_restriction                   = try(var.instance.site_config.scm_use_main_ip_restriction, null)
    use_32_bit_worker                             = try(var.instance.site_config.use_32_bit_worker, true)
    vnet_route_all_enabled                        = try(var.instance.site_config.vnet_route_all_enabled, false)
    websockets_enabled                            = try(var.instance.site_config.websockets_enabled, false)
    worker_count                                  = try(var.instance.site_config.worker_count, null)

    dynamic "application_stack" {
      for_each = lookup(each.value.site_config, "application_stack", null) != null ? [lookup(each.value.site_config, "application_stack")] : []

      content {
        current_stack                = try(application_stack.value.current_stack, null)
        docker_image_name            = try(application_stack.value.docker_image_name, null)
        docker_registry_url          = try(application_stack.value.docker_registry_url, null)
        docker_registry_username     = try(application_stack.value.docker_registry_username, null)
        docker_registry_password     = try(application_stack.value.docker_registry_password, null)
        dotnet_version               = try(application_stack.value.dotnet_version, null)
        dotnet_core_version          = try(application_stack.value.dotnet_core_version, null)
        tomcat_version               = try(application_stack.value.tomcat_version, null)
        java_embedded_server_enabled = try(application_stack.value.java_embedded_server_enabled, null)
        java_version                 = try(application_stack.value.java_version, null)
        node_version                 = try(application_stack.value.node_version, null)
        php_version                  = try(application_stack.value.php_version, null)
        python                       = try(application_stack.value.python, false)
      }
    }

    dynamic "auto_heal_setting" {
      for_each = lookup(each.value.site_config, "auto_heal_setting", null) != null ? [lookup(each.value.site_config, "auto_heal_setting")] : []

      content {
        dynamic "action" {
          for_each = lookup(auto_heal_setting.value, "action", null) != null ? [lookup(auto_heal_setting.value, "action")] : []
          content {
            action_type                    = action.value.action_type
            minimum_process_execution_time = try(action.value.minimum_process_execution_time, null)
          }
        }

        dynamic "trigger" {
          for_each = lookup(auto_heal_setting.value, "trigger", null) != null ? [lookup(auto_heal_setting.value, "trigger")] : []
          content {
            dynamic "requests" {
              for_each = lookup(trigger.value, "requests", null) != null ? [lookup(trigger.value, "requests")] : []
              content {
                count    = requests.value.count
                interval = requests.value.interval
              }
            }
            dynamic "slow_request" {
              for_each = lookup(trigger.value, "slow_request", null) != null ? [lookup(trigger.value, "slow_request")] : []
              content {
                count      = slow_requests.value.count
                interval   = slow_requests.value.interval
                time_taken = slow_requests.value.time_taken
              }
            }
            dynamic "slow_request_with_path" {
              for_each = lookup(trigger.value, "slow_request_with_path", null) != null ? [lookup(trigger.value, "slow_request_with_path")] : []
              content {
                count      = slow_requests.value.count
                interval   = slow_requests.value.interval
                time_taken = slow_requests.value.time_taken
                path       = try(slow_requests.value.path, null)
              }
            }
            dynamic "status_code" {
              for_each = lookup(trigger.value, "status_code", null) != null ? [lookup(trigger.value, "status_code")] : []
              content {
                count             = status_code.value.count
                interval          = status_code.value.interval
                status_code_range = status_code.value.status_code_range
                path              = try(status_code.value.path, null)
                sub_status        = try(status_code.value.sub_status, null)
                win32_status_code = try(status_code.value.win32_status_code, null)
              }
            }
          }
        }
      }
    }

    dynamic "cors" {
      for_each = lookup(each.value.site_config, "cors", null) != null ? [lookup(each.value.site_config, "cors")] : []
      content {
        allowed_origins     = try(cors.value.allowed_origins, null)
        support_credentials = try(cors.value.support_credentials, false)
      }
    }

    dynamic "ip_restriction" {
      for_each = {
        for key, ip_restriction in lookup(each.value.site_config, "ip_restrictions", []) : key => ip_restriction
      }
      content {
        name                      = try(ip_restriction.value.name, each.key)
        action                    = try(ip_restriction.value.action, "Allow")
        ip_address                = try(ip_restriction.value.ip_address, null)
        priority                  = try(ip_restriction.value.priority, 65000)
        service_tag               = try(ip_restriction.value.service_tag, null)
        virtual_network_subnet_id = try(ip_restriction.value.virtual_network_subnet_id, null)
        description               = try(ip_restriction.value.description, null)

        dynamic "headers" {
          for_each = lookup(ip_restriction.value, "headers", null) != null ? [lookup(ip_restriction.value, "headers")] : []
          content {
            x_azure_fdid      = try(headers.value.x_azure_fdid, [])
            x_fd_health_probe = try(headers.value.x_fd_health_probe, null)
            x_forwarded_for   = try(headers.value.x_forwarded_for, [])
            x_forwarded_host  = try(headers.value.x_forwarded_host, [])
          }
        }
      }
    }

    dynamic "scm_ip_restriction" {
      for_each = {
        for key, ip_restriction in lookup(each.value.site_config, "scm_ip_restrictions", []) : key => ip_restriction
      }
      content {
        action                    = try(scm_ip_restriction.value.action, "Allow")
        ip_address                = try(scm_ip_restriction.value.ip_address, null)
        name                      = try(scm_ip_restriction.value.name, null)
        priority                  = try(scm_ip_restriction.value.priority, 65000)
        service_tag               = try(scm_ip_restriction.value.service_tag, null)
        virtual_network_subnet_id = try(scm_ip_restriction.value.virtual_network_subnet_id, null)
        description               = try(scm_ip_restriction.value.description, null)

        dynamic "headers" {
          for_each = lookup(scm_ip_restriction.value, "headers", null) != null ? [lookup(scm_ip_restriction.value, "headers")] : []
          content {
            x_azure_fdid      = try(headers.value.x_azure_fdid, [])
            x_fd_health_probe = try(headers.value.x_fd_health_probe, null)
            x_forwarded_for   = try(headers.value.x_forwarded_for, [])
            x_forwarded_host  = try(headers.value.x_forwarded_host, [])
          }
        }
      }
    }
  }

  dynamic "auth_settings" {
    for_each = try(var.instance.auth_settings, null) != null ? { default = var.instance.auth_settings } : {}
    content {
      enabled                        = auth_settings.value.enabled
      additional_login_parameters    = try(auth_settings.value.additional_login_parameters, null)
      allowed_external_redirect_urls = try(auth_settings.value.allowed_external_redirect_urls, null)
      default_provider               = try(auth_settings.value.default_provider, null)
      issuer                         = try(auth_settings.value.issuer, null)
      runtime_version                = try(auth_settings.value.runtime_version, null)
      token_refresh_extension_hours  = try(auth_settings.value.token_refresh_extension_hours, 72)
      token_store_enabled            = try(auth_settings.value.token_store_enabled, false)
      unauthenticated_client_action  = try(auth_settings.value.unauthenticated_client_action, null)

      dynamic "active_directory" {
        for_each = lookup(auth_settings.value, "active_directory", null) != null ? [lookup(auth_settings.value, "active_directory")] : []

        content {
          client_id                  = active_directory.value.client_id
          allowed_audiences          = active_directory.value.allowed_audiences
          client_secret              = try(active_directory.value.client_secret, null)
          client_secret_setting_name = try(active_directory.value.client_secret_setting_name, null)
        }
      }

      dynamic "facebook" {
        for_each = lookup(auth_settings.value, "facebook", null) != null ? [lookup(auth_settings.value, "facebook")] : []
        content {
          app_id                  = facebook.value.app_id
          app_secret              = try(facebook.value.app_secret, null)
          app_secret_setting_name = try(facebook.value.app_secret_setting_name, null)
          oauth_scopes            = try(facebook.value.oauth_scopes, null)
        }
      }

      dynamic "github" {
        for_each = lookup(auth_settings.value, "github", null) != null ? [lookup(auth_settings.value, "github")] : []
        content {
          client_id                  = github.value.client_id
          client_secret              = try(github.value.client_secret, null)
          client_secret_setting_name = try(github.value.client_secret_setting_name, null)
          oauth_scopes               = try(github.value.oauth_scopes, null)
        }
      }

      dynamic "google" {
        for_each = lookup(auth_settings.value, "google", null) != null ? [lookup(auth_settings.value, "google")] : []
        content {
          client_id                  = google.value.client_id
          client_secret              = try(google.value.client_secret, null)
          client_secret_setting_name = try(google.value.client_secret_setting_name, null)
          oauth_scopes               = try(google.value.oauth_scopes, null)
        }
      }

      dynamic "microsoft" {
        for_each = lookup(auth_settings.value, "microsoft", null) != null ? [lookup(auth_settings.value, "microsoft")] : []
        content {
          client_id                  = microsoft.value.client_id
          client_secret              = try(microsoft.value.client_secret, null)
          client_secret_setting_name = try(microsoft.value.client_secret_setting_name, null)
          oauth_scopes               = try(microsoft.value.oauth_scopes, null)
        }
      }

      dynamic "twitter" {
        for_each = lookup(auth_settings.value, "twitter", null) != null ? [lookup(auth_settings.value, "twitter")] : []
        content {
          consumer_key                 = twitter.value.consumer_key
          consumer_secret              = try(twitter.value.consumer_secret, null)
          consumer_secret_setting_name = try(twitter.value.consumer_secret_setting_name, null)
        }
      }
    }
  }

  dynamic "auth_settings_v2" {
    for_each = try(var.instance.auth_settings_v2, null) != null ? { default = var.instance.auth_settings_v2 } : {}
    content {
      auth_enabled                            = try(auth_settings_v2.value.auth_enabled, null)
      runtime_version                         = try(auth_settings_v2.value.runtime_version, "~1")
      config_file_path                        = try(auth_settings_v2.value.config_file_path, null)
      require_authentication                  = try(auth_settings_v2.value.require_authentication, null)
      unauthenticated_action                  = try(auth_settings_v2.value.unauthenticated_action, null)
      default_provider                        = try(auth_settings_v2.value.default_provider, null)
      excluded_paths                          = try(auth_settings_v2.value.excluded_paths, null)
      require_https                           = try(auth_settings_v2.value.require_https, true)
      http_route_api_prefix                   = try(auth_settings_v2.value.http_route_api_prefix, "/.auth")
      forward_proxy_convention                = try(auth_settings_v2.value.forward_proxy_convention, "NoProxy")
      forward_proxy_custom_host_header_name   = try(auth_settings_v2.value.forward_proxy_custom_host_header_name, null)
      forward_proxy_custom_scheme_header_name = try(auth_settings_v2.value.forward_proxy_custom_scheme_header_name, null)

      dynamic "login" {
        for_each = lookup(auth_settings_v2.value, "login", null) != null ? [lookup(auth_settings_v2.value, "login")] : []
        content {
          logout_endpoint                   = try(login.value.logout_endpoint, null)
          token_store_enabled               = try(login.value.token_store_enabled, false)
          token_refresh_extension_time      = try(login.value.token_refresh_extension_time, 72)
          token_store_path                  = try(login.value.token_store_path, null)
          token_store_sas_setting_name      = try(login.value.token_store_sas_setting_name, null)
          preserve_url_fragments_for_logins = try(login.value.preserve_url_fragments_for_logins, false)
          allowed_external_redirect_urls    = try(login.value.allowed_external_redirect_urls, [])
          cookie_expiration_convention      = try(login.value.cookie_expiration_convention, "FixedTime")
          cookie_expiration_time            = try(login.value.cookie_expiration_time, "08:00:00")
          validate_nonce                    = try(login.value.validate_nonce, true)
          nonce_expiration_time             = try(login.value.nonce_expiration_time, "00:05:00")
        }
      }

      dynamic "apple_v2" {
        for_each = lookup(auth_settings_v2.value, "apple_v2", null) != null ? [lookup(auth_settings_v2.value, "apple_v2")] : []
        content {
          client_id                  = apple_v2.value.client_id
          client_secret_setting_name = apple_v2.value.client_secret_setting_name
          login_scopes               = apple_v2.value.login_scopes

        }
      }

      dynamic "active_directory_v2" {
        for_each = lookup(auth_settings_v2.value, "active_directory_v2", null) != null ? [lookup(auth_settings_v2.value, "active_directory_v2")] : []
        content {
          client_id                            = active_directory_v2.value.client_id
          tenant_auth_endpoint                 = active_directory_v2.value.tenant_auth_endpoint
          client_secret_setting_name           = try(active_directory_v2.value.client_secret_setting_name, null)
          client_secret_certificate_thumbprint = try(active_directory_v2.value.client_secret_certificate_thumbprint, null)
          jwt_allowed_groups                   = try(active_directory_v2.value.jwt_allowed_groups, [])
          jwt_allowed_client_applications      = try(active_directory_v2.value.jwt_allowed_client_applications, [])
          www_authentication_disabled          = try(active_directory_v2.value.www_authentication_disabled, false)
          allowed_applications                 = try(active_directory_v2.value.allowed_applications, [])
          allowed_audiences                    = try(active_directory_v2.value.allowed_audiences, [])
          allowed_groups                       = try(active_directory_v2.value.allowed_groups, [])
          allowed_identities                   = try(active_directory_v2.value.allowed_identities, [])

        }
      }

      dynamic "azure_static_web_app_v2" {
        for_each = lookup(auth_settings_v2.value, "azure_static_web_app_v2", null) != null ? [lookup(auth_settings_v2.value, "azure_static_web_app_v2")] : []
        content {
          client_id = azure_static_web_app_v2.value.client_id
        }
      }

      dynamic "custom_oidc_v2" {
        for_each = lookup(auth_settings_v2.value, "custom_oidc_v2", null) != null ? [lookup(auth_settings_v2.value, "custom_oidc_v2")] : []
        content {
          name                          = custom_oidc_v2.value.name
          client_id                     = custom_oidc_v2.value.client_id
          openid_configuration_endpoint = custom_oidc_v2.value.openid_configuration_endpoint
          name_claim_type               = try(custom_oidc_v2.value.name_clame_type, null)
          scopes                        = try(custom_oidc_v2.value.scopes, [])
          client_credential_method      = try(custom_oidc_v2.value.client_credential_method, null)
          client_secret_setting_name    = try(custom_oidc_v2.value.client_secret_setting_name, "${custom_oidc_v2.value.name}_PROVIDER_AUTHENTICATION_SECRET")
          authorisation_endpoint        = try(custom_oidc_v2.value.authorisation_endpoint, null)
          token_endpoint                = try(custom_oidc_v2.value.token_endpoint, null)
          issuer_endpoint               = try(custom_oidc_v2.value.issuer_endpoint, null)
          certification_uri             = try(custom_oidc_v2.value.certification_uri, null)
        }
      }

      dynamic "facebook_v2" {
        for_each = lookup(auth_settings_v2.value, "facebook_v2", null) != null ? [lookup(auth_settings_v2.value, "facebook_v2")] : []
        content {
          app_id                  = facebook_v2.value.app_id
          app_secret_setting_name = facebook_v2.value.app_secret_setting_name
          graph_api_version       = try(facebook_v2.value.graph_api_version, null)
          login_scopes            = try(facebook_v2.value.login_scopes, [])
        }
      }

      dynamic "github_v2" {
        for_each = lookup(auth_settings_v2.value, "github_v2", null) != null ? [lookup(auth_settings_v2.value, "github_v2")] : []
        content {
          client_id                  = github_v2.value.client_id
          client_secret_setting_name = github_v2.value.client_secret_setting_name
          login_scopes               = try(github_v2.value.login_scopes, [])
        }
      }

      dynamic "google_v2" {
        for_each = lookup(auth_settings_v2.value, "google_v2", null) != null ? [lookup(auth_settings_v2.value, "google_v2")] : []
        content {
          client_id                  = google_v2.value.client_id
          client_secret_setting_name = google_v2.value.client_secret_setting_name
          allowed_audiences          = try(google_v2.value.allowed_audiences, [])
          login_scopes               = try(google_v2.value.login_scopes, [])
        }
      }

      dynamic "microsoft_v2" {
        for_each = lookup(auth_settings_v2.value, "microsoft_v2", null) != null ? [lookup(auth_settings_v2.value, "microsoft_v2")] : []
        content {
          client_id                  = microsoft_v2.value.client_id
          client_secret_setting_name = microsoft_v2.value.client_secret_setting_name
          allowed_audiences          = try(microsoft_v2.value.allowed_audiences, [])
          login_scopes               = try(microsoft_v2.value.login_scopes, [])
        }
      }

      dynamic "twitter_v2" {
        for_each = lookup(auth_settings_v2.value, "twitter_v2", null) != null ? [lookup(auth_settings_v2.value, "twitter_v2")] : []
        content {
          consumer_key                 = twitter_v2.value.consumer_key
          consumer_secret_setting_name = twitter_v2.value.consumer_secret_setting_name
        }
      }
    }
  }

  dynamic "backup" {
    for_each = try(var.instance.backup, null) != null ? { default = var.instance.backup } : {}
    content {
      enabled             = try(backup.value.enabled, true)
      name                = backup.value.name
      storage_account_url = backup.value.storage_account_url

      dynamic "schedule" {
        for_each = lookup(backup.value, "schedule", null) != null ? [lookup(backup.value, "schedule")] : []
        content {
          frequency_interval       = schedule.value.frequency_interval
          frequency_unit           = schedule.value.frequency_unit
          keep_at_least_one_backup = try(schedule.value.keep_at_least_one_backup, false)
          retention_period_days    = try(schedule.value.retention_period_days, 30)
          start_time               = try(schedule.value.start_time, null)
        }
      }
    }
  }

  dynamic "connection_string" {
    for_each = try(var.instance.connection_string, null) != null ? { default = var.instance.connection_string } : {}
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  dynamic "identity" {
    for_each = [lookup(var.instance, "identity", { type = "SystemAssigned", identity_ids = [] })]

    content {
      type = identity.value.type
      identity_ids = concat(
        try([azurerm_user_assigned_identity.identity["identity"].id], []),
        lookup(identity.value, "identity_ids", [])
      )
    }
  }

  dynamic "logs" {
    for_each = try(var.instance.logs, null) != null ? { default = var.instance.logs } : {}
    content {
      detailed_error_messages = try(logs.value.detailed_error_messages, null)
      failed_request_tracing  = try(logs.value.failed_request_tracing, null)

      dynamic "application_logs" {
        for_each = lookup(logs.value, "application_logs", null) != null ? [lookup(logs.value, "application_logs")] : []
        content {
          file_system_level = application_logs.value.file_system_level
          dynamic "azure_blob_storage" {
            for_each = lookup(each.value.application_logs, "azure_blob_storage", null) != null ? [lookup(each.value.application_logs, "azure_blob_storage")] : []
            content {
              level             = azure_blob_storage.value.level
              sas_url           = azure_blob_storage.value.sas_url
              retention_in_days = try(azure_blob_storage.value.retention_in_days, 0)
            }
          }
        }
      }

      dynamic "http_logs" {
        for_each = lookup(each.value.logs, "http_logs", null) != null ? [lookup(each.value.logs, "http_logs")] : []
        content {
          dynamic "azure_blob_storage" {
            for_each = lookup(http_logs.value, "azure_blob_storage", null) != null ? [lookup(http_logs.value, "azure_blob_storage")] : []
            content {
              sas_url           = azure_blob_storage.value.sas_url
              retention_in_days = try(azure_blob_storage.value.retention_in_days, 0)
            }
          }
          dynamic "file_system" {
            for_each = lookup(http_logs.value, "file_system", null) != null ? [lookup(http_logs.value, "file_system")] : []
            content {
              retention_in_days = try(file_system.value.retention_in_days, 0)
              retention_in_mb   = file_system.value.retention_in_mb
            }
          }
        }
      }
    }
  }

  dynamic "storage_account" {
    for_each = try(var.instance.storage_account, null) != null ? { default = var.instance.storage_account } : {}
    content {
      access_key   = storage_account.value.access_key
      account_name = storage_account.value.account_name
      name         = storage_account.value.name
      share_name   = storage_account.value.share_name
      type         = storage_account.value.type
      mount_path   = try(storage_account.value.mount_path, null)
    }
  }
}

# user assigned identity
resource "azurerm_user_assigned_identity" "identity" {
  for_each = contains(["UserAssigned", "SystemAssigned, UserAssigned"], try(var.instance.identity.type, "")) ? { "identity" = var.instance.identity } : {}

  name                = try(each.value.name, "uai-${var.instance.name}")
  resource_group_name = coalesce(lookup(var.instance, "resource_group", null), var.resource_group)
  location            = coalesce(lookup(var.instance, "location", null), var.location)
  tags                = try(var.instance.tags, var.tags, {})
}
