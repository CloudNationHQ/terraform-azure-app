# linux web app
resource "azurerm_linux_web_app" "linux" {
  for_each = var.instance.type == "linux" ? {
    (var.instance.name) = var.instance
  } : {}

  resource_group_name = coalesce(
    lookup(
      var.instance, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(var.instance, "location", null
    ), var.location
  )

  name                                           = var.instance.name
  service_plan_id                                = var.instance.service_plan_id
  app_settings                                   = var.instance.app_settings
  client_affinity_enabled                        = var.instance.client_affinity_enabled
  client_certificate_enabled                     = var.instance.client_certificate_enabled
  client_certificate_mode                        = var.instance.client_certificate_mode
  client_certificate_exclusion_paths             = var.instance.client_certificate_exclusion_paths
  enabled                                        = var.instance.enabled
  ftp_publish_basic_authentication_enabled       = var.instance.ftp_publish_basic_authentication_enabled
  https_only                                     = var.instance.https_only
  public_network_access_enabled                  = var.instance.public_network_access_enabled
  key_vault_reference_identity_id                = var.instance.key_vault_reference_identity_id
  virtual_network_subnet_id                      = var.instance.virtual_network_subnet_id
  vnet_image_pull_enabled                        = var.instance.vnet_image_pull_enabled
  webdeploy_publish_basic_authentication_enabled = var.instance.webdeploy_publish_basic_authentication_enabled
  zip_deploy_file                                = var.instance.zip_deploy_file
  virtual_network_backup_restore_enabled         = var.instance.virtual_network_backup_restore_enabled

  tags = coalesce(
    var.instance.tags, var.tags
  )

  site_config {
    always_on                                     = var.instance.site_config.always_on
    api_definition_url                            = var.instance.site_config.api_definition_url
    api_management_api_id                         = var.instance.site_config.api_management_api_id
    app_command_line                              = var.instance.site_config.app_command_line
    container_registry_managed_identity_client_id = var.instance.site_config.container_registry_managed_identity_client_id
    container_registry_use_managed_identity       = var.instance.site_config.container_registry_use_managed_identity
    default_documents                             = var.instance.site_config.default_documents
    ftps_state                                    = var.instance.site_config.ftps_state
    health_check_path                             = var.instance.site_config.health_check_path
    health_check_eviction_time_in_min             = var.instance.site_config.health_check_eviction_time_in_min
    http2_enabled                                 = var.instance.site_config.http2_enabled
    ip_restriction_default_action                 = var.instance.site_config.ip_restriction_default_action
    load_balancing_mode                           = var.instance.site_config.load_balancing_mode
    local_mysql_enabled                           = var.instance.site_config.local_mysql_enabled
    managed_pipeline_mode                         = var.instance.site_config.managed_pipeline_mode
    minimum_tls_version                           = var.instance.site_config.minimum_tls_version
    remote_debugging_enabled                      = var.instance.site_config.remote_debugging_enabled
    scm_ip_restriction_default_action             = var.instance.site_config.scm_ip_restriction_default_action
    scm_use_main_ip_restriction                   = var.instance.site_config.scm_use_main_ip_restriction
    use_32_bit_worker                             = var.instance.site_config.use_32_bit_worker
    vnet_route_all_enabled                        = var.instance.site_config.vnet_route_all_enabled
    websockets_enabled                            = var.instance.site_config.websockets_enabled
    worker_count                                  = var.instance.site_config.worker_count
    scm_minimum_tls_version                       = var.instance.site_config.scm_minimum_tls_version
    remote_debugging_version                      = var.instance.site_config.remote_debugging_version

    dynamic "application_stack" {
      for_each = each.value.site_config.application_stack != null ? [each.value.site_config.application_stack] : []

      content {
        docker_image_name        = application_stack.value.docker_image_name
        docker_registry_url      = application_stack.value.docker_registry_url
        docker_registry_username = application_stack.value.docker_registry_username
        docker_registry_password = application_stack.value.docker_registry_password
        dotnet_version           = application_stack.value.dotnet_version
        go_version               = application_stack.value.go_version
        java_server              = application_stack.value.java_server
        java_server_version      = application_stack.value.java_server_version
        java_version             = application_stack.value.java_version
        node_version             = application_stack.value.node_version
        php_version              = application_stack.value.php_version
        python_version           = application_stack.value.python_version
        ruby_version             = application_stack.value.ruby_version
      }
    }

    dynamic "auto_heal_setting" {
      for_each = each.value.site_config.auto_heal_setting != null ? [each.value.site_config.auto_heal_setting] : []

      content {
        dynamic "action" {
          for_each = auto_heal_setting.value.action != null ? [auto_heal_setting.value.action] : []

          content {
            action_type                    = action.value.action_type
            minimum_process_execution_time = action.value.minimum_process_execution_time
          }
        }

        dynamic "trigger" {
          for_each = auto_heal_setting.value.trigger != null ? [auto_heal_setting.value.trigger] : []

          content {
            dynamic "requests" {
              for_each = trigger.value.requests != null ? [trigger.value.requests] : []

              content {
                count    = requests.value.count
                interval = requests.value.interval
              }
            }

            dynamic "slow_request" {
              for_each = trigger.value.slow_request != null ? [trigger.value.slow_request] : []

              content {
                count      = slow_request.value.count
                interval   = slow_request.value.interval
                time_taken = slow_request.value.time_taken
              }
            }
            dynamic "slow_request_with_path" {
              for_each = trigger.value.slow_request_with_path != null ? [trigger.value.slow_request_with_path] : []

              content {
                count      = slow_request_with_path.value.count
                interval   = slow_request_with_path.value.interval
                time_taken = slow_request_with_path.value.time_taken
                path       = slow_request_with_path.value.path
              }
            }

            dynamic "status_code" {
              for_each = trigger.value.status_code != null ? [trigger.value.status_code] : []

              content {
                count             = status_code.value.count
                interval          = status_code.value.interval
                status_code_range = status_code.value.status_code_range
                path              = status_code.value.path
                sub_status        = status_code.value.sub_status
                win32_status_code = status_code.value.win32_status_code
              }
            }
          }
        }
      }
    }

    dynamic "cors" {
      for_each = each.value.site_config.cors != null ? [each.value.site_config.cors] : []

      content {
        allowed_origins     = cors.value.allowed_origins
        support_credentials = cors.value.support_credentials
      }
    }

    dynamic "ip_restriction" {
      for_each = lookup(
        each.value.site_config, "ip_restrictions", {}
      )

      content {
        name                      = ip_restriction.value.name
        action                    = ip_restriction.value.action
        ip_address                = ip_restriction.value.ip_address
        priority                  = ip_restriction.value.priority
        service_tag               = ip_restriction.value.service_tag
        virtual_network_subnet_id = ip_restriction.value.virtual_network_subnet_id
        description               = ip_restriction.value.description

        dynamic "headers" {
          for_each = ip_restriction.value.headers != null ? [ip_restriction.value.headers] : []

          content {
            x_azure_fdid      = headers.value.x_azure_fdid
            x_fd_health_probe = headers.value.x_fd_health_probe
            x_forwarded_for   = headers.value.x_forwarded_for
            x_forwarded_host  = headers.value.x_forwarded_host
          }
        }
      }
    }

    dynamic "scm_ip_restriction" {
      for_each = lookup(
        each.value.site_config, "scm_ip_restrictions", {}
      )

      content {
        action                    = scm_ip_restriction.value.action
        ip_address                = scm_ip_restriction.value.ip_address
        name                      = scm_ip_restriction.value.name
        priority                  = scm_ip_restriction.value.priority
        service_tag               = scm_ip_restriction.value.service_tag
        virtual_network_subnet_id = scm_ip_restriction.value.virtual_network_subnet_id
        description               = scm_ip_restriction.value.description

        dynamic "headers" {
          for_each = scm_ip_restriction.value.headers != null ? [scm_ip_restriction.value.headers] : []

          content {
            x_azure_fdid      = headers.value.x_azure_fdid
            x_fd_health_probe = headers.value.x_fd_health_probe
            x_forwarded_for   = headers.value.x_forwarded_for
            x_forwarded_host  = headers.value.x_forwarded_host
          }
        }
      }
    }
  }

  dynamic "auth_settings" {
    for_each = each.value.auth_settings != null ? [each.value.auth_settings] : []

    content {
      enabled                        = auth_settings.value.enabled
      additional_login_parameters    = auth_settings.value.additional_login_parameters
      allowed_external_redirect_urls = auth_settings.value.allowed_external_redirect_urls
      default_provider               = auth_settings.value.default_provider
      issuer                         = auth_settings.value.issuer
      runtime_version                = auth_settings.value.runtime_version
      token_refresh_extension_hours  = auth_settings.value.token_refresh_extension_hours
      token_store_enabled            = auth_settings.value.token_store_enabled
      unauthenticated_client_action  = auth_settings.value.unauthenticated_client_action

      dynamic "active_directory" {
        for_each = auth_settings.value.active_directory != null ? [auth_settings.value.active_directory] : []

        content {
          client_id                  = active_directory.value.client_id
          allowed_audiences          = active_directory.value.allowed_audiences
          client_secret              = active_directory.value.client_secret
          client_secret_setting_name = active_directory.value.client_secret_setting_name
        }
      }

      dynamic "facebook" {
        for_each = auth_settings.value.facebook != null ? [auth_settings.value.facebook] : []

        content {
          app_id                  = facebook.value.app_id
          app_secret              = facebook.value.app_secret
          app_secret_setting_name = facebook.value.app_secret_setting_name
          oauth_scopes            = facebook.value.oauth_scopes
        }
      }

      dynamic "github" {
        for_each = auth_settings.value.github != null ? [auth_settings.value.github] : []

        content {
          client_id                  = github.value.client_id
          client_secret              = github.value.client_secret
          client_secret_setting_name = github.value.client_secret_setting_name
          oauth_scopes               = github.value.oauth_scopes
        }
      }

      dynamic "google" {
        for_each = auth_settings.value.google != null ? [auth_settings.value.google] : []

        content {
          client_id                  = google.value.client_id
          client_secret              = google.value.client_secret
          client_secret_setting_name = google.value.client_secret_setting_name
          oauth_scopes               = google.value.oauth_scopes
        }
      }

      dynamic "microsoft" {
        for_each = auth_settings.value.microsoft != null ? [auth_settings.value.microsoft] : []

        content {
          client_id                  = microsoft.value.client_id
          client_secret              = microsoft.value.client_secret
          client_secret_setting_name = microsoft.value.client_secret_setting_name
          oauth_scopes               = microsoft.value.oauth_scopes
        }
      }

      dynamic "twitter" {
        for_each = auth_settings.value.twitter != null ? [auth_settings.value.twitter] : []

        content {
          consumer_key                 = twitter.value.consumer_key
          consumer_secret              = twitter.value.consumer_secret
          consumer_secret_setting_name = twitter.value.consumer_secret_setting_name
        }
      }
    }
  }

  dynamic "auth_settings_v2" {
    for_each = each.value.auth_settings_v2 != null ? [each.value.auth_settings_v2] : []

    content {
      auth_enabled                            = auth_settings_v2.value.auth_enabled
      runtime_version                         = auth_settings_v2.value.runtime_version
      config_file_path                        = auth_settings_v2.value.config_file_path
      require_authentication                  = auth_settings_v2.value.require_authentication
      unauthenticated_action                  = auth_settings_v2.value.unauthenticated_action
      default_provider                        = auth_settings_v2.value.default_provider
      excluded_paths                          = auth_settings_v2.value.excluded_paths
      require_https                           = auth_settings_v2.value.require_https
      http_route_api_prefix                   = auth_settings_v2.value.http_route_api_prefix
      forward_proxy_convention                = auth_settings_v2.value.forward_proxy_convention
      forward_proxy_custom_host_header_name   = auth_settings_v2.value.forward_proxy_custom_host_header_name
      forward_proxy_custom_scheme_header_name = auth_settings_v2.value.forward_proxy_custom_scheme_header_name

      dynamic "login" {
        for_each = auth_settings_v2.value.login != null ? [auth_settings_v2.value.login] : []

        content {
          logout_endpoint                   = login.value.logout_endpoint
          token_store_enabled               = login.value.token_store_enabled
          token_refresh_extension_time      = login.value.token_refresh_extension_time
          token_store_path                  = login.value.token_store_path
          token_store_sas_setting_name      = login.value.token_store_sas_setting_name
          preserve_url_fragments_for_logins = login.value.preserve_url_fragments_for_logins
          allowed_external_redirect_urls    = login.value.allowed_external_redirect_urls
          cookie_expiration_convention      = login.value.cookie_expiration_convention
          cookie_expiration_time            = login.value.cookie_expiration_time
          validate_nonce                    = login.value.validate_nonce
          nonce_expiration_time             = login.value.nonce_expiration_time
        }
      }

      dynamic "apple_v2" {
        for_each = auth_settings_v2.value.apple_v2 != null ? [auth_settings_v2.value.apple_v2] : []

        content {
          client_id                  = apple_v2.value.client_id
          client_secret_setting_name = apple_v2.value.client_secret_setting_name
          login_scopes               = apple_v2.value.login_scopes
        }
      }

      dynamic "active_directory_v2" {
        for_each = auth_settings_v2.value.active_directory_v2 != null ? [auth_settings_v2.value.active_directory_v2] : []

        content {
          client_id                            = active_directory_v2.value.client_id
          tenant_auth_endpoint                 = active_directory_v2.value.tenant_auth_endpoint
          client_secret_setting_name           = active_directory_v2.value.client_secret_setting_name
          client_secret_certificate_thumbprint = active_directory_v2.value.client_secret_certificate_thumbprint
          jwt_allowed_groups                   = active_directory_v2.value.jwt_allowed_groups
          jwt_allowed_client_applications      = active_directory_v2.value.jwt_allowed_client_applications
          www_authentication_disabled          = active_directory_v2.value.www_authentication_disabled
          allowed_applications                 = active_directory_v2.value.allowed_applications
          allowed_audiences                    = active_directory_v2.value.allowed_audiences
          allowed_groups                       = active_directory_v2.value.allowed_groups
          allowed_identities                   = active_directory_v2.value.allowed_identities
          login_parameters                     = active_directory_v2.value.login_parameters
        }
      }

      dynamic "azure_static_web_app_v2" {
        for_each = auth_settings_v2.value.azure_static_web_app_v2 != null ? [auth_settings_v2.value.azure_static_web_app_v2] : []

        content {
          client_id = azure_static_web_app_v2.value.client_id
        }
      }

      dynamic "custom_oidc_v2" {
        for_each = auth_settings_v2.value.custom_oidc_v2 != null ? auth_settings_v2.value.custom_oidc_v2 : {}

        content {
          name                          = custom_oidc_v2.value.name
          client_id                     = custom_oidc_v2.value.client_id
          openid_configuration_endpoint = custom_oidc_v2.value.openid_configuration_endpoint
          name_claim_type               = custom_oidc_v2.value.name_claim_type
          scopes                        = custom_oidc_v2.value.scopes
          client_credential_method      = custom_oidc_v2.value.client_credential_method
          client_secret_setting_name    = custom_oidc_v2.value.client_secret_setting_name
          authorisation_endpoint        = custom_oidc_v2.value.authorisation_endpoint
          token_endpoint                = custom_oidc_v2.value.token_endpoint
          issuer_endpoint               = custom_oidc_v2.value.issuer_endpoint
          certification_uri             = custom_oidc_v2.value.certification_uri
        }
      }

      dynamic "facebook_v2" {
        for_each = auth_settings_v2.value.facebook_v2 != null ? [auth_settings_v2.value.facebook_v2] : []

        content {
          app_id                  = facebook_v2.value.app_id
          app_secret_setting_name = facebook_v2.value.app_secret_setting_name
          graph_api_version       = facebook_v2.value.graph_api_version
          login_scopes            = facebook_v2.value.login_scopes
        }
      }

      dynamic "github_v2" {
        for_each = auth_settings_v2.value.github_v2 != null ? [auth_settings_v2.value.github_v2] : []

        content {
          client_id                  = github_v2.value.client_id
          client_secret_setting_name = github_v2.value.client_secret_setting_name
          login_scopes               = github_v2.value.login_scopes
        }
      }

      dynamic "google_v2" {
        for_each = auth_settings_v2.value.google_v2 != null ? [auth_settings_v2.value.google_v2] : []

        content {
          client_id                  = google_v2.value.client_id
          client_secret_setting_name = google_v2.value.client_secret_setting_name
          allowed_audiences          = google_v2.value.allowed_audiences
          login_scopes               = google_v2.value.login_scopes
        }
      }

      dynamic "microsoft_v2" {
        for_each = auth_settings_v2.value.microsoft_v2 != null ? [auth_settings_v2.value.microsoft_v2] : []

        content {
          client_id                  = microsoft_v2.value.client_id
          client_secret_setting_name = microsoft_v2.value.client_secret_setting_name
          allowed_audiences          = microsoft_v2.value.allowed_audiences
          login_scopes               = microsoft_v2.value.login_scopes
        }
      }

      dynamic "twitter_v2" {
        for_each = auth_settings_v2.value.twitter_v2 != null ? [auth_settings_v2.value.twitter_v2] : []

        content {
          consumer_key                 = twitter_v2.value.consumer_key
          consumer_secret_setting_name = twitter_v2.value.consumer_secret_setting_name
        }
      }
    }
  }

  dynamic "backup" {
    for_each = each.value.backup != null ? [each.value.backup] : []

    content {
      enabled             = backup.value.enabled
      name                = backup.value.name
      storage_account_url = backup.value.storage_account_url

      dynamic "schedule" {
        for_each = backup.value.schedule != null ? [backup.value.schedule] : []

        content {
          frequency_interval       = schedule.value.frequency_interval
          frequency_unit           = schedule.value.frequency_unit
          keep_at_least_one_backup = schedule.value.keep_at_least_one_backup
          retention_period_days    = schedule.value.retention_period_days
          start_time               = schedule.value.start_time
        }
      }
    }
  }

  dynamic "connection_string" {
    for_each = lookup(
      each.value, "connection_strings", {}
    )

    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  dynamic "identity" {
    for_each = each.value.identity != null ? [each.value.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "logs" {
    for_each = each.value.logs != null ? [each.value.logs] : []

    content {
      detailed_error_messages = logs.value.detailed_error_messages
      failed_request_tracing  = logs.value.failed_request_tracing

      dynamic "application_logs" {
        for_each = logs.value.application_logs != null ? [logs.value.application_logs] : []

        content {
          file_system_level = application_logs.value.file_system_level

          dynamic "azure_blob_storage" {
            for_each = application_logs.value.azure_blob_storage != null ? [application_logs.value.azure_blob_storage] : []

            content {
              level             = azure_blob_storage.value.level
              sas_url           = azure_blob_storage.value.sas_url
              retention_in_days = azure_blob_storage.value.retention_in_days
            }
          }
        }
      }

      dynamic "http_logs" {
        for_each = each.value.logs.http_logs != null ? [each.value.logs.http_logs] : []

        content {
          dynamic "azure_blob_storage" {
            for_each = http_logs.value.azure_blob_storage != null ? [http_logs.value.azure_blob_storage] : []

            content {
              sas_url           = azure_blob_storage.value.sas_url
              retention_in_days = azure_blob_storage.value.retention_in_days
            }
          }

          dynamic "file_system" {
            for_each = http_logs.value.file_system != null ? [http_logs.value.file_system] : []

            content {
              retention_in_days = file_system.value.retention_in_days
              retention_in_mb   = file_system.value.retention_in_mb
            }
          }
        }
      }
    }
  }

  dynamic "storage_account" {
    for_each = lookup(
      each.value, "storage_accounts", {}
    )

    content {
      name = lookup(
        storage_account.value, "name", storage_account.key
      )

      type         = storage_account.value.type
      share_name   = storage_account.value.share_name
      access_key   = storage_account.value.access_key
      account_name = storage_account.value.account_name
      mount_path   = storage_account.value.mount_path
    }
  }

  dynamic "sticky_settings" {
    for_each = each.value.sticky_settings != null ? [each.value.sticky_settings] : []

    content {
      app_setting_names       = sticky_settings.value.app_setting_names
      connection_string_names = sticky_settings.value.connection_string_names
    }
  }
}

# linux web app slot
resource "azurerm_linux_web_app_slot" "linux" {
  for_each = var.instance.type == "linux" ? (var.instance.slots != null ? var.instance.slots : {}) : {}

  name = try(
    each.value.name, each.key
  )

  app_service_id                                 = azurerm_linux_web_app.linux[var.instance.name].id
  app_settings                                   = each.value.app_settings
  client_affinity_enabled                        = each.value.client_affinity_enabled
  client_certificate_enabled                     = each.value.client_certificate_enabled
  client_certificate_mode                        = each.value.client_certificate_mode
  client_certificate_exclusion_paths             = each.value.client_certificate_exclusion_paths
  enabled                                        = each.value.enabled
  ftp_publish_basic_authentication_enabled       = each.value.ftp_publish_basic_authentication_enabled
  https_only                                     = each.value.https_only
  public_network_access_enabled                  = each.value.public_network_access_enabled
  key_vault_reference_identity_id                = each.value.key_vault_reference_identity_id
  virtual_network_subnet_id                      = each.value.virtual_network_subnet_id
  vnet_image_pull_enabled                        = each.value.vnet_image_pull_enabled
  webdeploy_publish_basic_authentication_enabled = each.value.webdeploy_publish_basic_authentication_enabled
  zip_deploy_file                                = each.value.zip_deploy_file
  virtual_network_backup_restore_enabled         = each.value.virtual_network_backup_restore_enabled
  service_plan_id                                = each.value.service_plan_id

  tags = coalesce(
    each.value.tags, var.instance.tags, var.tags
  )

  site_config {
    always_on                                     = each.value.site_config.always_on
    api_definition_url                            = each.value.site_config.api_definition_url
    api_management_api_id                         = each.value.site_config.api_management_api_id
    app_command_line                              = each.value.site_config.app_command_line
    container_registry_managed_identity_client_id = each.value.site_config.container_registry_managed_identity_client_id
    container_registry_use_managed_identity       = each.value.site_config.container_registry_use_managed_identity
    default_documents                             = each.value.site_config.default_documents
    ftps_state                                    = each.value.site_config.ftps_state
    health_check_path                             = each.value.site_config.health_check_path
    health_check_eviction_time_in_min             = each.value.site_config.health_check_eviction_time_in_min
    http2_enabled                                 = each.value.site_config.http2_enabled
    ip_restriction_default_action                 = each.value.site_config.ip_restriction_default_action
    load_balancing_mode                           = each.value.site_config.load_balancing_mode
    local_mysql_enabled                           = each.value.site_config.local_mysql_enabled
    managed_pipeline_mode                         = each.value.site_config.managed_pipeline_mode
    minimum_tls_version                           = each.value.site_config.minimum_tls_version
    remote_debugging_enabled                      = each.value.site_config.remote_debugging_enabled
    scm_ip_restriction_default_action             = each.value.site_config.scm_ip_restriction_default_action
    scm_use_main_ip_restriction                   = each.value.site_config.scm_use_main_ip_restriction
    use_32_bit_worker                             = each.value.site_config.use_32_bit_worker
    vnet_route_all_enabled                        = each.value.site_config.vnet_route_all_enabled
    websockets_enabled                            = each.value.site_config.websockets_enabled
    worker_count                                  = each.value.site_config.worker_count
    remote_debugging_version                      = each.value.site_config.remote_debugging_version
    scm_minimum_tls_version                       = each.value.site_config.scm_minimum_tls_version
    auto_swap_slot_name                           = each.value.site_config.auto_swap_slot_name

    dynamic "application_stack" {
      for_each = each.value.site_config.application_stack != null ? [each.value.site_config.application_stack] : []

      content {
        docker_image_name        = application_stack.value.docker_image_name
        docker_registry_url      = application_stack.value.docker_registry_url
        docker_registry_username = application_stack.value.docker_registry_username
        docker_registry_password = application_stack.value.docker_registry_password
        dotnet_version           = application_stack.value.dotnet_version
        go_version               = application_stack.value.go_version
        java_server              = application_stack.value.java_server
        java_server_version      = application_stack.value.java_server_version
        java_version             = application_stack.value.java_version
        node_version             = application_stack.value.node_version
        php_version              = application_stack.value.php_version
        python_version           = application_stack.value.python_version
        ruby_version             = application_stack.value.ruby_version
      }
    }

    dynamic "auto_heal_setting" {
      for_each = each.value.site_config.auto_heal_setting != null ? [each.value.site_config.auto_heal_setting] : []

      content {
        dynamic "action" {
          for_each = auto_heal_setting.value.action != null ? [auto_heal_setting.value.action] : []

          content {
            action_type                    = action.value.action_type
            minimum_process_execution_time = action.value.minimum_process_execution_time
          }
        }

        dynamic "trigger" {
          for_each = auto_heal_setting.value.trigger != null ? [auto_heal_setting.value.trigger] : []

          content {
            dynamic "requests" {
              for_each = trigger.value.requests != null ? [trigger.value.requests] : []

              content {
                count    = requests.value.count
                interval = requests.value.interval
              }
            }

            dynamic "slow_request" {
              for_each = trigger.value.slow_request != null ? [trigger.value.slow_request] : []

              content {
                count      = slow_request.value.count
                interval   = slow_request.value.interval
                time_taken = slow_request.value.time_taken
              }
            }

            dynamic "slow_request_with_path" {
              for_each = trigger.value.slow_request_with_path != null ? [trigger.value.slow_request_with_path] : []

              content {
                count      = slow_request_with_path.value.count
                interval   = slow_request_with_path.value.interval
                time_taken = slow_request_with_path.value.time_taken
                path       = slow_request_with_path.value.path
              }
            }
            dynamic "status_code" {
              for_each = trigger.value.status_code != null ? [trigger.value.status_code] : []

              content {
                count             = status_code.value.count
                interval          = status_code.value.interval
                status_code_range = status_code.value.status_code_range
                path              = status_code.value.path
                sub_status        = status_code.value.sub_status
                win32_status_code = status_code.value.win32_status_code
              }
            }
          }
        }
      }
    }

    dynamic "cors" {
      for_each = each.value.site_config.cors != null ? [each.value.site_config.cors] : []

      content {
        allowed_origins     = cors.value.allowed_origins
        support_credentials = cors.value.support_credentials
      }
    }

    dynamic "ip_restriction" {
      for_each = lookup(
        each.value.site_config, "ip_restrictions", {}
      )

      content {
        name                      = ip_restriction.value.name
        action                    = ip_restriction.value.action
        ip_address                = ip_restriction.value.ip_address
        priority                  = ip_restriction.value.priority
        service_tag               = ip_restriction.value.service_tag
        virtual_network_subnet_id = ip_restriction.value.virtual_network_subnet_id
        description               = ip_restriction.value.description

        dynamic "headers" {
          for_each = ip_restriction.value.headers != null ? [ip_restriction.value.headers] : []

          content {
            x_azure_fdid      = headers.value.x_azure_fdid
            x_fd_health_probe = headers.value.x_fd_health_probe
            x_forwarded_for   = headers.value.x_forwarded_for
            x_forwarded_host  = headers.value.x_forwarded_host
          }
        }
      }
    }

    dynamic "scm_ip_restriction" {
      for_each = lookup(
        each.value.site_config, "scm_ip_restrictions", {}
      )

      content {
        action                    = scm_ip_restriction.value.action
        ip_address                = scm_ip_restriction.value.ip_address
        name                      = scm_ip_restriction.value.name
        priority                  = scm_ip_restriction.value.priority
        service_tag               = scm_ip_restriction.value.service_tag
        virtual_network_subnet_id = scm_ip_restriction.value.virtual_network_subnet_id
        description               = scm_ip_restriction.value.description

        dynamic "headers" {
          for_each = scm_ip_restriction.value.headers != null ? [scm_ip_restriction.value.headers] : []

          content {
            x_azure_fdid      = headers.value.x_azure_fdid
            x_fd_health_probe = headers.value.x_fd_health_probe
            x_forwarded_for   = headers.value.x_forwarded_for
            x_forwarded_host  = headers.value.x_forwarded_host
          }
        }
      }
    }
  }

  dynamic "auth_settings" {
    for_each = each.value.auth_settings != null ? [each.value.auth_settings] : []

    content {
      enabled                        = auth_settings.value.enabled
      additional_login_parameters    = auth_settings.value.additional_login_parameters
      allowed_external_redirect_urls = auth_settings.value.allowed_external_redirect_urls
      default_provider               = auth_settings.value.default_provider
      issuer                         = auth_settings.value.issuer
      runtime_version                = auth_settings.value.runtime_version
      token_refresh_extension_hours  = auth_settings.value.token_refresh_extension_hours
      token_store_enabled            = auth_settings.value.token_store_enabled
      unauthenticated_client_action  = auth_settings.value.unauthenticated_client_action

      dynamic "active_directory" {
        for_each = auth_settings.value.active_directory != null ? [auth_settings.value.active_directory] : []

        content {
          client_id                  = active_directory.value.client_id
          allowed_audiences          = active_directory.value.allowed_audiences
          client_secret              = active_directory.value.client_secret
          client_secret_setting_name = active_directory.value.client_secret_setting_name
        }
      }

      dynamic "facebook" {
        for_each = auth_settings.value.facebook != null ? [auth_settings.value.facebook] : []

        content {
          app_id                  = facebook.value.app_id
          app_secret              = facebook.value.app_secret
          app_secret_setting_name = facebook.value.app_secret_setting_name
          oauth_scopes            = facebook.value.oauth_scopes
        }
      }

      dynamic "github" {
        for_each = auth_settings.value.github != null ? [auth_settings.value.github] : []

        content {
          client_id                  = github.value.client_id
          client_secret              = github.value.client_secret
          client_secret_setting_name = github.value.client_secret_setting_name
          oauth_scopes               = github.value.oauth_scopes
        }
      }

      dynamic "google" {
        for_each = auth_settings.value.google != null ? [auth_settings.value.google] : []

        content {
          client_id                  = google.value.client_id
          client_secret              = google.value.client_secret
          client_secret_setting_name = google.value.client_secret_setting_name
          oauth_scopes               = google.value.oauth_scopes
        }
      }

      dynamic "microsoft" {
        for_each = auth_settings.value.microsoft != null ? [auth_settings.value.microsoft] : []

        content {
          client_id                  = microsoft.value.client_id
          client_secret              = microsoft.value.client_secret
          client_secret_setting_name = microsoft.value.client_secret_setting_name
          oauth_scopes               = microsoft.value.oauth_scopes
        }
      }

      dynamic "twitter" {
        for_each = auth_settings.value.twitter != null ? [auth_settings.value.twitter] : []

        content {
          consumer_key                 = twitter.value.consumer_key
          consumer_secret              = twitter.value.consumer_secret
          consumer_secret_setting_name = twitter.value.consumer_secret_setting_name
        }
      }
    }
  }

  dynamic "auth_settings_v2" {
    for_each = each.value.auth_settings_v2 != null ? [each.value.auth_settings_v2] : []

    content {
      auth_enabled                            = auth_settings_v2.value.auth_enabled
      runtime_version                         = auth_settings_v2.value.runtime_version
      config_file_path                        = auth_settings_v2.value.config_file_path
      require_authentication                  = auth_settings_v2.value.require_authentication
      unauthenticated_action                  = auth_settings_v2.value.unauthenticated_action
      default_provider                        = auth_settings_v2.value.default_provider
      excluded_paths                          = auth_settings_v2.value.excluded_paths
      require_https                           = auth_settings_v2.value.require_https
      http_route_api_prefix                   = auth_settings_v2.value.http_route_api_prefix
      forward_proxy_convention                = auth_settings_v2.value.forward_proxy_convention
      forward_proxy_custom_host_header_name   = auth_settings_v2.value.forward_proxy_custom_host_header_name
      forward_proxy_custom_scheme_header_name = auth_settings_v2.value.forward_proxy_custom_scheme_header_name

      dynamic "login" {
        for_each = auth_settings_v2.value.login != null ? [auth_settings_v2.value.login] : []

        content {
          logout_endpoint                   = login.value.logout_endpoint
          token_store_enabled               = login.value.token_store_enabled
          token_refresh_extension_time      = login.value.token_refresh_extension_time
          token_store_path                  = login.value.token_store_path
          token_store_sas_setting_name      = login.value.token_store_sas_setting_name
          preserve_url_fragments_for_logins = login.value.preserve_url_fragments_for_logins
          allowed_external_redirect_urls    = login.value.allowed_external_redirect_urls
          cookie_expiration_convention      = login.value.cookie_expiration_convention
          cookie_expiration_time            = login.value.cookie_expiration_time
          validate_nonce                    = login.value.validate_nonce
          nonce_expiration_time             = login.value.nonce_expiration_time
        }
      }

      dynamic "apple_v2" {
        for_each = auth_settings_v2.value.apple_v2 != null ? [auth_settings_v2.value.apple_v2] : []

        content {
          client_id                  = apple_v2.value.client_id
          client_secret_setting_name = apple_v2.value.client_secret_setting_name
          login_scopes               = apple_v2.value.login_scopes

        }
      }

      dynamic "active_directory_v2" {
        for_each = auth_settings_v2.value.active_directory_v2 != null ? [auth_settings_v2.value.active_directory_v2] : []

        content {
          client_id                            = active_directory_v2.value.client_id
          tenant_auth_endpoint                 = active_directory_v2.value.tenant_auth_endpoint
          client_secret_setting_name           = active_directory_v2.value.client_secret_setting_name
          client_secret_certificate_thumbprint = active_directory_v2.value.client_secret_certificate_thumbprint
          jwt_allowed_groups                   = active_directory_v2.value.jwt_allowed_groups
          jwt_allowed_client_applications      = active_directory_v2.value.jwt_allowed_client_applications
          www_authentication_disabled          = active_directory_v2.value.www_authentication_disabled
          allowed_applications                 = active_directory_v2.value.allowed_applications
          allowed_audiences                    = active_directory_v2.value.allowed_audiences
          allowed_groups                       = active_directory_v2.value.allowed_groups
          allowed_identities                   = active_directory_v2.value.allowed_identities
          login_parameters                     = active_directory_v2.value.login_parameters
        }
      }

      dynamic "azure_static_web_app_v2" {
        for_each = auth_settings_v2.value.azure_static_web_app_v2 != null ? [auth_settings_v2.value.azure_static_web_app_v2] : []

        content {
          client_id = azure_static_web_app_v2.value.client_id
        }
      }

      dynamic "custom_oidc_v2" {
        for_each = auth_settings_v2.value.custom_oidc_v2 != null ? auth_settings_v2.value.custom_oidc_v2 : {}

        content {
          name                          = custom_oidc_v2.value.name
          client_id                     = custom_oidc_v2.value.client_id
          openid_configuration_endpoint = custom_oidc_v2.value.openid_configuration_endpoint
          name_claim_type               = custom_oidc_v2.value.name_claim_type
          scopes                        = custom_oidc_v2.value.scopes
          client_credential_method      = custom_oidc_v2.value.client_credential_method
          authorisation_endpoint        = custom_oidc_v2.value.authorisation_endpoint
          token_endpoint                = custom_oidc_v2.value.token_endpoint
          issuer_endpoint               = custom_oidc_v2.value.issuer_endpoint
          certification_uri             = custom_oidc_v2.value.certification_uri
          client_secret_setting_name    = try(custom_oidc_v2.value.client_secret_setting_name, "${custom_oidc_v2.value.name}_PROVIDER_AUTHENTICATION_SECRET")
        }
      }

      dynamic "facebook_v2" {
        for_each = auth_settings_v2.value.facebook_v2 != null ? [auth_settings_v2.value.facebook_v2] : []

        content {
          app_id                  = facebook_v2.value.app_id
          app_secret_setting_name = facebook_v2.value.app_secret_setting_name
          graph_api_version       = facebook_v2.value.graph_api_version
          login_scopes            = facebook_v2.value.login_scopes
        }
      }

      dynamic "github_v2" {
        for_each = auth_settings_v2.value.github_v2 != null ? [auth_settings_v2.value.github_v2] : []

        content {
          client_id                  = github_v2.value.client_id
          client_secret_setting_name = github_v2.value.client_secret_setting_name
          login_scopes               = github_v2.value.login_scopes
        }
      }

      dynamic "google_v2" {
        for_each = auth_settings_v2.value.google_v2 != null ? [auth_settings_v2.value.google_v2] : []

        content {
          client_id                  = google_v2.value.client_id
          client_secret_setting_name = google_v2.value.client_secret_setting_name
          allowed_audiences          = google_v2.value.allowed_audiences
          login_scopes               = google_v2.value.login_scopes
        }
      }

      dynamic "microsoft_v2" {
        for_each = auth_settings_v2.value.microsoft_v2 != null ? [auth_settings_v2.value.microsoft_v2] : []

        content {
          client_id                  = microsoft_v2.value.client_id
          client_secret_setting_name = microsoft_v2.value.client_secret_setting_name
          allowed_audiences          = microsoft_v2.value.allowed_audiences
          login_scopes               = microsoft_v2.value.login_scopes
        }
      }

      dynamic "twitter_v2" {
        for_each = auth_settings_v2.value.twitter_v2 != null ? [auth_settings_v2.value.twitter_v2] : []

        content {
          consumer_key                 = twitter_v2.value.consumer_key
          consumer_secret_setting_name = twitter_v2.value.consumer_secret_setting_name
        }
      }
    }
  }

  dynamic "backup" {
    for_each = each.value.backup != null ? [each.value.backup] : []

    content {
      enabled             = backup.value.enabled
      name                = backup.value.name
      storage_account_url = backup.value.storage_account_url

      dynamic "schedule" {
        for_each = backup.value.schedule != null ? [backup.value.schedule] : []

        content {
          frequency_interval       = schedule.value.frequency_interval
          frequency_unit           = schedule.value.frequency_unit
          keep_at_least_one_backup = schedule.value.keep_at_least_one_backup
          retention_period_days    = schedule.value.retention_period_days
          start_time               = schedule.value.start_time
        }
      }
    }
  }

  dynamic "connection_string" {
    for_each = lookup(
      each.value, "connection_strings", {}
    )

    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  dynamic "identity" {
    for_each = each.value.identity != null ? [each.value.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "logs" {
    for_each = each.value.logs != null ? [each.value.logs] : []

    content {
      detailed_error_messages = logs.value.detailed_error_messages
      failed_request_tracing  = logs.value.failed_request_tracing

      dynamic "application_logs" {
        for_each = logs.value.application_logs != null ? [logs.value.application_logs] : []

        content {
          file_system_level = application_logs.value.file_system_level

          dynamic "azure_blob_storage" {
            for_each = application_logs.value.azure_blob_storage != null ? [application_logs.value.azure_blob_storage] : []

            content {
              level             = azure_blob_storage.value.level
              sas_url           = azure_blob_storage.value.sas_url
              retention_in_days = azure_blob_storage.value.retention_in_days
            }
          }
        }
      }

      dynamic "http_logs" {
        for_each = each.value.logs.http_logs != null ? [each.value.logs.http_logs] : []

        content {
          dynamic "azure_blob_storage" {
            for_each = http_logs.value.azure_blob_storage != null ? [http_logs.value.azure_blob_storage] : []

            content {
              sas_url           = azure_blob_storage.value.sas_url
              retention_in_days = azure_blob_storage.value.retention_in_days
            }
          }

          dynamic "file_system" {
            for_each = http_logs.value.file_system != null ? [http_logs.value.file_system] : []

            content {
              retention_in_days = file_system.value.retention_in_days
              retention_in_mb   = file_system.value.retention_in_mb
            }
          }
        }
      }
    }
  }

  dynamic "storage_account" {
    for_each = lookup(
      each.value, "storage_accounts", {}
    )

    content {
      name = lookup(
        storage_account.value, "name", storage_account.key
      )

      type         = storage_account.value.type
      share_name   = storage_account.value.share_name
      access_key   = storage_account.value.access_key
      account_name = storage_account.value.account_name
      mount_path   = storage_account.value.mount_path
    }
  }
}

# windows web app
resource "azurerm_windows_web_app" "windows" {
  for_each = var.instance.type == "windows" ? {
    (var.instance.name) = var.instance
  } : {}

  resource_group_name = coalesce(
    lookup(
      var.instance, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(var.instance, "location", null
    ), var.location
  )

  name                                           = var.instance.name
  service_plan_id                                = var.instance.service_plan_id
  app_settings                                   = var.instance.app_settings
  client_affinity_enabled                        = var.instance.client_affinity_enabled
  client_certificate_enabled                     = var.instance.client_certificate_enabled
  client_certificate_mode                        = var.instance.client_certificate_mode
  client_certificate_exclusion_paths             = var.instance.client_certificate_exclusion_paths
  enabled                                        = var.instance.enabled
  ftp_publish_basic_authentication_enabled       = var.instance.ftp_publish_basic_authentication_enabled
  https_only                                     = var.instance.https_only
  public_network_access_enabled                  = var.instance.public_network_access_enabled
  key_vault_reference_identity_id                = var.instance.key_vault_reference_identity_id
  virtual_network_subnet_id                      = var.instance.virtual_network_subnet_id
  virtual_network_image_pull_enabled             = var.instance.virtual_network_image_pull_enabled
  webdeploy_publish_basic_authentication_enabled = var.instance.webdeploy_publish_basic_authentication_enabled
  zip_deploy_file                                = var.instance.zip_deploy_file
  virtual_network_backup_restore_enabled         = var.instance.virtual_network_backup_restore_enabled

  tags = coalesce(
    var.instance.tags, var.tags
  )

  site_config {
    always_on                                     = var.instance.site_config.always_on
    api_definition_url                            = var.instance.site_config.api_definition_url
    api_management_api_id                         = var.instance.site_config.api_management_api_id
    app_command_line                              = var.instance.site_config.app_command_line
    container_registry_managed_identity_client_id = var.instance.site_config.container_registry_managed_identity_client_id
    container_registry_use_managed_identity       = var.instance.site_config.container_registry_use_managed_identity
    default_documents                             = var.instance.site_config.default_documents
    ftps_state                                    = var.instance.site_config.ftps_state
    health_check_path                             = var.instance.site_config.health_check_path
    health_check_eviction_time_in_min             = var.instance.site_config.health_check_eviction_time_in_min
    http2_enabled                                 = var.instance.site_config.http2_enabled
    ip_restriction_default_action                 = var.instance.site_config.ip_restriction_default_action
    load_balancing_mode                           = var.instance.site_config.load_balancing_mode
    local_mysql_enabled                           = var.instance.site_config.local_mysql_enabled
    managed_pipeline_mode                         = var.instance.site_config.managed_pipeline_mode
    minimum_tls_version                           = var.instance.site_config.minimum_tls_version
    remote_debugging_enabled                      = var.instance.site_config.remote_debugging_enabled
    scm_ip_restriction_default_action             = var.instance.site_config.scm_ip_restriction_default_action
    scm_use_main_ip_restriction                   = var.instance.site_config.scm_use_main_ip_restriction
    use_32_bit_worker                             = var.instance.site_config.use_32_bit_worker
    vnet_route_all_enabled                        = var.instance.site_config.vnet_route_all_enabled
    websockets_enabled                            = var.instance.site_config.websockets_enabled
    worker_count                                  = var.instance.site_config.worker_count
    remote_debugging_version                      = var.instance.site_config.remote_debugging_version
    scm_minimum_tls_version                       = var.instance.site_config.scm_minimum_tls_version

    dynamic "application_stack" {
      for_each = each.value.site_config.application_stack != null ? [each.value.site_config.application_stack] : []

      content {
        current_stack                = application_stack.value.current_stack
        docker_image_name            = application_stack.value.docker_image_name
        docker_registry_url          = application_stack.value.docker_registry_url
        docker_registry_username     = application_stack.value.docker_registry_username
        docker_registry_password     = application_stack.value.docker_registry_password
        dotnet_version               = application_stack.value.dotnet_version
        dotnet_core_version          = application_stack.value.dotnet_core_version
        tomcat_version               = application_stack.value.tomcat_version
        java_embedded_server_enabled = application_stack.value.java_embedded_server_enabled
        java_version                 = application_stack.value.java_version
        node_version                 = application_stack.value.node_version
        php_version                  = application_stack.value.php_version
        python                       = application_stack.value.python
      }
    }

    dynamic "auto_heal_setting" {
      for_each = each.value.site_config.auto_heal_setting != null ? [each.value.site_config.auto_heal_setting] : []

      content {
        dynamic "action" {
          for_each = auto_heal_setting.value.action != null ? [auto_heal_setting.value.action] : []

          content {
            action_type                    = action.value.action_type
            minimum_process_execution_time = action.value.minimum_process_execution_time

            dynamic "custom_action" {
              for_each = action.value.custom_action != null ? [action.value.custom_action] : []

              content {
                executable = custom_action.value.executable
                parameters = custom_action.value.parameters
              }
            }
          }
        }

        dynamic "trigger" {
          for_each = auto_heal_setting.value.trigger != null ? [auto_heal_setting.value.trigger] : []

          content {
            private_memory_kb = trigger.value.private_memory_kb

            dynamic "requests" {
              for_each = trigger.value.requests != null ? [trigger.value.requests] : []

              content {
                count    = requests.value.count
                interval = requests.value.interval
              }
            }
            dynamic "slow_request" {
              for_each = trigger.value.slow_request != null ? [trigger.value.slow_request] : []

              content {
                count      = slow_request.value.count
                interval   = slow_request.value.interval
                time_taken = slow_request.value.time_taken
              }
            }
            dynamic "slow_request_with_path" {
              for_each = trigger.value.slow_request_with_path != null ? [trigger.value.slow_request_with_path] : []

              content {
                count      = slow_request_with_path.value.count
                interval   = slow_request_with_path.value.interval
                time_taken = slow_request_with_path.value.time_taken
                path       = slow_request_with_path.value.path
              }
            }

            dynamic "status_code" {
              for_each = trigger.value.status_code != null ? [trigger.value.status_code] : []

              content {
                count             = status_code.value.count
                interval          = status_code.value.interval
                status_code_range = status_code.value.status_code_range
                path              = status_code.value.path
                sub_status        = status_code.value.sub_status
                win32_status_code = status_code.value.win32_status_code
              }
            }
          }
        }
      }
    }

    dynamic "cors" {
      for_each = each.value.site_config.cors != null ? [each.value.site_config.cors] : []

      content {
        allowed_origins     = cors.value.allowed_origins
        support_credentials = cors.value.support_credentials
      }
    }

    dynamic "handler_mapping" {
      for_each = lookup(
        each.value.site_config, "handler_mappings", {}
      )

      content {
        arguments             = handler_mapping.value.arguments
        extension             = handler_mapping.value.extension
        script_processor_path = handler_mapping.value.script_processor_path
      }
    }

    dynamic "virtual_application" {
      for_each = lookup(
        each.value.site_config, "virtual_applications", {}
      )

      content {
        virtual_path  = virtual_application.value.virtual_path
        physical_path = virtual_application.value.physical_path
        preload       = virtual_application.value.preload

        dynamic "virtual_directory" {
          for_each = lookup(
            virtual_application.value, "virtual_directories", {}
          )

          content {
            physical_path = virtual_directory.value.physical_path
            virtual_path  = virtual_directory.value.virtual_path
          }
        }
      }
    }

    dynamic "ip_restriction" {
      for_each = lookup(
        each.value.site_config, "ip_restrictions", {}
      )

      content {
        name                      = ip_restriction.value.name
        action                    = ip_restriction.value.action
        ip_address                = ip_restriction.value.ip_address
        priority                  = ip_restriction.value.priority
        service_tag               = ip_restriction.value.service_tag
        virtual_network_subnet_id = ip_restriction.value.virtual_network_subnet_id
        description               = ip_restriction.value.description

        dynamic "headers" {
          for_each = ip_restriction.value.headers != null ? [ip_restriction.value.headers] : []

          content {
            x_azure_fdid      = headers.value.x_azure_fdid
            x_fd_health_probe = headers.value.x_fd_health_probe
            x_forwarded_for   = headers.value.x_forwarded_for
            x_forwarded_host  = headers.value.x_forwarded_host
          }
        }
      }
    }

    dynamic "scm_ip_restriction" {
      for_each = lookup(
        each.value.site_config, "scm_ip_restrictions", {}
      )

      content {
        action                    = scm_ip_restriction.value.action
        ip_address                = scm_ip_restriction.value.ip_address
        name                      = scm_ip_restriction.value.name
        priority                  = scm_ip_restriction.value.priority
        service_tag               = scm_ip_restriction.value.service_tag
        virtual_network_subnet_id = scm_ip_restriction.value.virtual_network_subnet_id
        description               = scm_ip_restriction.value.description

        dynamic "headers" {
          for_each = scm_ip_restriction.value.headers != null ? [scm_ip_restriction.value.headers] : []

          content {
            x_azure_fdid      = headers.value.x_azure_fdid
            x_fd_health_probe = headers.value.x_fd_health_probe
            x_forwarded_for   = headers.value.x_forwarded_for
            x_forwarded_host  = headers.value.x_forwarded_host
          }
        }
      }
    }
  }

  dynamic "auth_settings" {
    for_each = each.value.auth_settings != null ? [each.value.auth_settings] : []

    content {
      enabled                        = auth_settings.value.enabled
      additional_login_parameters    = auth_settings.value.additional_login_parameters
      allowed_external_redirect_urls = auth_settings.value.allowed_external_redirect_urls
      default_provider               = auth_settings.value.default_provider
      issuer                         = auth_settings.value.issuer
      runtime_version                = auth_settings.value.runtime_version
      token_refresh_extension_hours  = auth_settings.value.token_refresh_extension_hours
      token_store_enabled            = auth_settings.value.token_store_enabled
      unauthenticated_client_action  = auth_settings.value.unauthenticated_client_action

      dynamic "active_directory" {
        for_each = auth_settings.value.active_directory != null ? [auth_settings.value.active_directory] : []

        content {
          client_id                  = active_directory.value.client_id
          allowed_audiences          = active_directory.value.allowed_audiences
          client_secret              = active_directory.value.client_secret
          client_secret_setting_name = active_directory.value.client_secret_setting_name
        }
      }

      dynamic "facebook" {
        for_each = auth_settings.value.facebook != null ? [auth_settings.value.facebook] : []

        content {
          app_id                  = facebook.value.app_id
          app_secret              = facebook.value.app_secret
          app_secret_setting_name = facebook.value.app_secret_setting_name
          oauth_scopes            = facebook.value.oauth_scopes
        }
      }

      dynamic "github" {
        for_each = auth_settings.value.github != null ? [auth_settings.value.github] : []

        content {
          client_id                  = github.value.client_id
          client_secret              = github.value.client_secret
          client_secret_setting_name = github.value.client_secret_setting_name
          oauth_scopes               = github.value.oauth_scopes
        }
      }

      dynamic "google" {
        for_each = auth_settings.value.google != null ? [auth_settings.value.google] : []

        content {
          client_id                  = google.value.client_id
          client_secret              = google.value.client_secret
          client_secret_setting_name = google.value.client_secret_setting_name
          oauth_scopes               = google.value.oauth_scopes
        }
      }

      dynamic "microsoft" {
        for_each = auth_settings.value.microsoft != null ? [auth_settings.value.microsoft] : []

        content {
          client_id                  = microsoft.value.client_id
          client_secret              = microsoft.value.client_secret
          client_secret_setting_name = microsoft.value.client_secret_setting_name
          oauth_scopes               = microsoft.value.oauth_scopes
        }
      }

      dynamic "twitter" {
        for_each = auth_settings.value.twitter != null ? [auth_settings.value.twitter] : []

        content {
          consumer_key                 = twitter.value.consumer_key
          consumer_secret              = twitter.value.consumer_secret
          consumer_secret_setting_name = twitter.value.consumer_secret_setting_name
        }
      }
    }
  }

  dynamic "auth_settings_v2" {
    for_each = each.value.auth_settings_v2 != null ? [each.value.auth_settings_v2] : []

    content {
      auth_enabled                            = auth_settings_v2.value.auth_enabled
      runtime_version                         = auth_settings_v2.value.runtime_version
      config_file_path                        = auth_settings_v2.value.config_file_path
      require_authentication                  = auth_settings_v2.value.require_authentication
      unauthenticated_action                  = auth_settings_v2.value.unauthenticated_action
      default_provider                        = auth_settings_v2.value.default_provider
      excluded_paths                          = auth_settings_v2.value.excluded_paths
      require_https                           = auth_settings_v2.value.require_https
      http_route_api_prefix                   = auth_settings_v2.value.http_route_api_prefix
      forward_proxy_convention                = auth_settings_v2.value.forward_proxy_convention
      forward_proxy_custom_host_header_name   = auth_settings_v2.value.forward_proxy_custom_host_header_name
      forward_proxy_custom_scheme_header_name = auth_settings_v2.value.forward_proxy_custom_scheme_header_name

      dynamic "login" {
        for_each = auth_settings_v2.value.login != null ? [auth_settings_v2.value.login] : []

        content {
          logout_endpoint                   = login.value.logout_endpoint
          token_store_enabled               = login.value.token_store_enabled
          token_refresh_extension_time      = login.value.token_refresh_extension_time
          token_store_path                  = login.value.token_store_path
          token_store_sas_setting_name      = login.value.token_store_sas_setting_name
          preserve_url_fragments_for_logins = login.value.preserve_url_fragments_for_logins
          allowed_external_redirect_urls    = login.value.allowed_external_redirect_urls
          cookie_expiration_convention      = login.value.cookie_expiration_convention
          cookie_expiration_time            = login.value.cookie_expiration_time
          validate_nonce                    = login.value.validate_nonce
          nonce_expiration_time             = login.value.nonce_expiration_time
        }
      }

      dynamic "apple_v2" {
        for_each = auth_settings_v2.value.apple_v2 != null ? [auth_settings_v2.value.apple_v2] : []

        content {
          client_id                  = apple_v2.value.client_id
          client_secret_setting_name = apple_v2.value.client_secret_setting_name
          login_scopes               = apple_v2.value.login_scopes
        }
      }

      dynamic "active_directory_v2" {
        for_each = auth_settings_v2.value.active_directory_v2 != null ? [auth_settings_v2.value.active_directory_v2] : []

        content {
          client_id                            = active_directory_v2.value.client_id
          tenant_auth_endpoint                 = active_directory_v2.value.tenant_auth_endpoint
          client_secret_setting_name           = active_directory_v2.value.client_secret_setting_name
          client_secret_certificate_thumbprint = active_directory_v2.value.client_secret_certificate_thumbprint
          jwt_allowed_groups                   = active_directory_v2.value.jwt_allowed_groups
          jwt_allowed_client_applications      = active_directory_v2.value.jwt_allowed_client_applications
          www_authentication_disabled          = active_directory_v2.value.www_authentication_disabled
          allowed_applications                 = active_directory_v2.value.allowed_applications
          allowed_audiences                    = active_directory_v2.value.allowed_audiences
          allowed_groups                       = active_directory_v2.value.allowed_groups
          allowed_identities                   = active_directory_v2.value.allowed_identities
          login_parameters                     = active_directory_v2.value.login_parameters
        }
      }

      dynamic "azure_static_web_app_v2" {
        for_each = auth_settings_v2.value.azure_static_web_app_v2 != null ? [auth_settings_v2.value.azure_static_web_app_v2] : []

        content {
          client_id = azure_static_web_app_v2.value.client_id
        }
      }

      dynamic "custom_oidc_v2" {
        for_each = auth_settings_v2.value.custom_oidc_v2 != null ? auth_settings_v2.value.custom_oidc_v2 : {}

        content {
          name                          = custom_oidc_v2.value.name
          client_id                     = custom_oidc_v2.value.client_id
          openid_configuration_endpoint = custom_oidc_v2.value.openid_configuration_endpoint
          name_claim_type               = custom_oidc_v2.value.name_claim_type
          scopes                        = custom_oidc_v2.value.scopes
          client_credential_method      = custom_oidc_v2.value.client_credential_method
          client_secret_setting_name    = custom_oidc_v2.value.client_secret_setting_name
          authorisation_endpoint        = custom_oidc_v2.value.authorisation_endpoint
          token_endpoint                = custom_oidc_v2.value.token_endpoint
          issuer_endpoint               = custom_oidc_v2.value.issuer_endpoint
          certification_uri             = custom_oidc_v2.value.certification_uri
        }
      }

      dynamic "facebook_v2" {
        for_each = auth_settings_v2.value.facebook_v2 != null ? [auth_settings_v2.value.facebook_v2] : []

        content {
          app_id                  = facebook_v2.value.app_id
          app_secret_setting_name = facebook_v2.value.app_secret_setting_name
          graph_api_version       = facebook_v2.value.graph_api_version
          login_scopes            = facebook_v2.value.login_scopes
        }
      }

      dynamic "github_v2" {
        for_each = auth_settings_v2.value.github_v2 != null ? [auth_settings_v2.value.github_v2] : []

        content {
          client_id                  = github_v2.value.client_id
          client_secret_setting_name = github_v2.value.client_secret_setting_name
          login_scopes               = github_v2.value.login_scopes
        }
      }

      dynamic "google_v2" {
        for_each = auth_settings_v2.value.google_v2 != null ? [auth_settings_v2.value.google_v2] : []

        content {
          client_id                  = google_v2.value.client_id
          client_secret_setting_name = google_v2.value.client_secret_setting_name
          allowed_audiences          = google_v2.value.allowed_audiences
          login_scopes               = google_v2.value.login_scopes
        }
      }

      dynamic "microsoft_v2" {
        for_each = auth_settings_v2.value.microsoft_v2 != null ? [auth_settings_v2.value.microsoft_v2] : []

        content {
          client_id                  = microsoft_v2.value.client_id
          client_secret_setting_name = microsoft_v2.value.client_secret_setting_name
          allowed_audiences          = microsoft_v2.value.allowed_audiences
          login_scopes               = microsoft_v2.value.login_scopes
        }
      }

      dynamic "twitter_v2" {
        for_each = auth_settings_v2.value.twitter_v2 != null ? [auth_settings_v2.value.twitter_v2] : []

        content {
          consumer_key                 = twitter_v2.value.consumer_key
          consumer_secret_setting_name = twitter_v2.value.consumer_secret_setting_name
        }
      }
    }
  }

  dynamic "backup" {
    for_each = each.value.backup != null ? [each.value.backup] : []

    content {
      enabled             = try(backup.value.enabled, true)
      name                = backup.value.name
      storage_account_url = backup.value.storage_account_url

      dynamic "schedule" {
        for_each = backup.value.schedule != null ? [backup.value.schedule] : []

        content {
          frequency_interval       = schedule.value.frequency_interval
          frequency_unit           = schedule.value.frequency_unit
          keep_at_least_one_backup = schedule.value.keep_at_least_one_backup
          retention_period_days    = schedule.value.retention_period_days
          start_time               = schedule.value.start_time
        }
      }
    }
  }

  dynamic "connection_string" {
    for_each = lookup(
      each.value, "connection_strings", {}
    )

    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  dynamic "identity" {
    for_each = each.value.identity != null ? [each.value.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "logs" {
    for_each = each.value.logs != null ? [each.value.logs] : []

    content {
      detailed_error_messages = logs.value.detailed_error_messages
      failed_request_tracing  = logs.value.failed_request_tracing

      dynamic "application_logs" {
        for_each = logs.value.application_logs != null ? [logs.value.application_logs] : []

        content {
          file_system_level = application_logs.value.file_system_level

          dynamic "azure_blob_storage" {
            for_each = application_logs.value.azure_blob_storage != null ? [application_logs.value.azure_blob_storage] : []

            content {
              level             = azure_blob_storage.value.level
              sas_url           = azure_blob_storage.value.sas_url
              retention_in_days = azure_blob_storage.value.retention_in_days
            }
          }
        }
      }

      dynamic "http_logs" {
        for_each = each.value.logs.http_logs != null ? [each.value.logs.http_logs] : []

        content {
          dynamic "azure_blob_storage" {
            for_each = http_logs.value.azure_blob_storage != null ? [http_logs.value.azure_blob_storage] : []

            content {
              sas_url           = azure_blob_storage.value.sas_url
              retention_in_days = azure_blob_storage.value.retention_in_days
            }
          }

          dynamic "file_system" {
            for_each = http_logs.value.file_system != null ? [http_logs.value.file_system] : []

            content {
              retention_in_days = file_system.value.retention_in_days
              retention_in_mb   = file_system.value.retention_in_mb
            }
          }
        }
      }
    }
  }

  dynamic "storage_account" {
    for_each = lookup(
      each.value, "storage_accounts", {}
    )

    content {
      name = lookup(
        storage_account.value, "name", storage_account.key
      )

      type         = storage_account.value.type
      share_name   = storage_account.value.share_name
      access_key   = storage_account.value.access_key
      account_name = storage_account.value.account_name
      mount_path   = storage_account.value.mount_path
    }
  }

  dynamic "sticky_settings" {
    for_each = each.value.sticky_settings != null ? [each.value.sticky_settings] : []

    content {
      app_setting_names       = sticky_settings.value.app_setting_names
      connection_string_names = sticky_settings.value.connection_string_names
    }
  }
}

# windows web app slot
resource "azurerm_windows_web_app_slot" "windows" {
  for_each = var.instance.type == "windows" ? (var.instance.slots != null ? var.instance.slots : {}) : {}

  name = try(
    each.value.name, each.key
  )

  app_service_id                                 = azurerm_windows_web_app.windows[var.instance.name].id
  app_settings                                   = each.value.app_settings
  client_affinity_enabled                        = each.value.client_affinity_enabled
  client_certificate_enabled                     = each.value.client_certificate_enabled
  client_certificate_mode                        = each.value.client_certificate_mode
  client_certificate_exclusion_paths             = each.value.client_certificate_exclusion_paths
  enabled                                        = each.value.enabled
  ftp_publish_basic_authentication_enabled       = each.value.ftp_publish_basic_authentication_enabled
  https_only                                     = each.value.https_only
  public_network_access_enabled                  = each.value.public_network_access_enabled
  key_vault_reference_identity_id                = each.value.key_vault_reference_identity_id
  virtual_network_subnet_id                      = each.value.virtual_network_subnet_id
  virtual_network_image_pull_enabled             = each.value.virtual_network_image_pull_enabled
  webdeploy_publish_basic_authentication_enabled = each.value.webdeploy_publish_basic_authentication_enabled
  zip_deploy_file                                = each.value.zip_deploy_file
  service_plan_id                                = each.value.service_plan_id
  virtual_network_backup_restore_enabled         = each.value.virtual_network_backup_restore_enabled

  tags = coalesce(
    each.value.tags, var.instance.tags, var.tags
  )

  site_config {
    always_on                                     = each.value.site_config.always_on
    api_definition_url                            = each.value.site_config.api_definition_url
    api_management_api_id                         = each.value.site_config.api_management_api_id
    app_command_line                              = each.value.site_config.app_command_line
    container_registry_managed_identity_client_id = each.value.site_config.container_registry_managed_identity_client_id
    container_registry_use_managed_identity       = each.value.site_config.container_registry_use_managed_identity
    default_documents                             = each.value.site_config.default_documents
    ftps_state                                    = each.value.site_config.ftps_state
    health_check_path                             = each.value.site_config.health_check_path
    health_check_eviction_time_in_min             = each.value.site_config.health_check_eviction_time_in_min
    http2_enabled                                 = each.value.site_config.http2_enabled
    ip_restriction_default_action                 = each.value.site_config.ip_restriction_default_action
    load_balancing_mode                           = each.value.site_config.load_balancing_mode
    local_mysql_enabled                           = each.value.site_config.local_mysql_enabled
    managed_pipeline_mode                         = each.value.site_config.managed_pipeline_mode
    minimum_tls_version                           = each.value.site_config.minimum_tls_version
    remote_debugging_enabled                      = each.value.site_config.remote_debugging_enabled
    scm_ip_restriction_default_action             = each.value.site_config.scm_ip_restriction_default_action
    scm_use_main_ip_restriction                   = each.value.site_config.scm_use_main_ip_restriction
    use_32_bit_worker                             = each.value.site_config.use_32_bit_worker
    vnet_route_all_enabled                        = each.value.site_config.vnet_route_all_enabled
    websockets_enabled                            = each.value.site_config.websockets_enabled
    worker_count                                  = each.value.site_config.worker_count
    auto_swap_slot_name                           = each.value.site_config.auto_swap_slot_name
    remote_debugging_version                      = each.value.site_config.remote_debugging_version
    scm_minimum_tls_version                       = each.value.site_config.scm_minimum_tls_version

    dynamic "virtual_application" {
      for_each = lookup(
        each.value.site_config, "virtual_applications", {}
      )

      content {
        virtual_path  = virtual_application.value.virtual_path
        physical_path = virtual_application.value.physical_path
        preload       = virtual_application.value.preload

        dynamic "virtual_directory" {
          for_each = lookup(
            virtual_application.value, "virtual_directories", {}
          )

          content {
            physical_path = virtual_directory.value.physical_path
            virtual_path  = virtual_directory.value.virtual_path
          }
        }
      }
    }

    dynamic "application_stack" {
      for_each = each.value.site_config.application_stack != null ? [each.value.site_config.application_stack] : []

      content {
        current_stack                = application_stack.value.current_stack
        docker_image_name            = application_stack.value.docker_image_name
        docker_registry_url          = application_stack.value.docker_registry_url
        docker_registry_username     = application_stack.value.docker_registry_username
        docker_registry_password     = application_stack.value.docker_registry_password
        dotnet_version               = application_stack.value.dotnet_version
        dotnet_core_version          = application_stack.value.dotnet_core_version
        tomcat_version               = application_stack.value.tomcat_version
        java_embedded_server_enabled = application_stack.value.java_embedded_server_enabled
        java_version                 = application_stack.value.java_version
        node_version                 = application_stack.value.node_version
        php_version                  = application_stack.value.php_version
        python                       = application_stack.value.python
      }
    }

    dynamic "auto_heal_setting" {
      for_each = each.value.site_config.auto_heal_setting != null ? [each.value.site_config.auto_heal_setting] : []

      content {
        dynamic "action" {
          for_each = auto_heal_setting.value.action != null ? [auto_heal_setting.value.action] : []

          content {
            action_type                    = action.value.action_type
            minimum_process_execution_time = action.value.minimum_process_execution_time

            dynamic "custom_action" {
              for_each = action.value.custom_action != null ? [action.value.custom_action] : []

              content {
                executable = custom_action.value.executable
                parameters = custom_action.value.parameters
              }
            }
          }
        }

        dynamic "trigger" {
          for_each = auto_heal_setting.value.trigger != null ? [auto_heal_setting.value.trigger] : []

          content {
            private_memory_kb = trigger.value.private_memory_kb

            dynamic "requests" {
              for_each = trigger.value.requests != null ? [trigger.value.requests] : []

              content {
                count    = requests.value.count
                interval = requests.value.interval
              }
            }

            dynamic "slow_request" {
              for_each = trigger.value.slow_request != null ? [trigger.value.slow_request] : []

              content {
                count      = slow_request.value.count
                interval   = slow_request.value.interval
                time_taken = slow_request.value.time_taken
              }
            }

            dynamic "slow_request_with_path" {
              for_each = trigger.value.slow_request_with_path != null ? [trigger.value.slow_request_with_path] : []

              content {

                count      = slow_request_with_path.value.count
                interval   = slow_request_with_path.value.interval
                time_taken = slow_request_with_path.value.time_taken
                path       = slow_request_with_path.value.path
              }
            }

            dynamic "status_code" {
              for_each = trigger.value.status_code != null ? [trigger.value.status_code] : []

              content {
                count             = status_code.value.count
                interval          = status_code.value.interval
                status_code_range = status_code.value.status_code_range
                path              = status_code.value.path
                sub_status        = status_code.value.sub_status
                win32_status_code = status_code.value.win32_status_code
              }
            }
          }
        }
      }
    }

    dynamic "cors" {
      for_each = each.value.site_config.cors != null ? [each.value.site_config.cors] : []

      content {
        allowed_origins     = cors.value.allowed_origins
        support_credentials = cors.value.support_credentials
      }
    }

    dynamic "handler_mapping" {
      for_each = lookup(
        each.value.site_config, "handler_mappings", {}
      )

      content {
        arguments             = handler_mapping.value.arguments
        extension             = handler_mapping.value.extension
        script_processor_path = handler_mapping.value.script_processor_path
      }
    }

    dynamic "ip_restriction" {
      for_each = lookup(
        each.value.site_config, "ip_restrictions", {}
      )

      content {
        name                      = ip_restriction.value.name
        action                    = ip_restriction.value.action
        ip_address                = ip_restriction.value.ip_address
        priority                  = ip_restriction.value.priority
        service_tag               = ip_restriction.value.service_tag
        virtual_network_subnet_id = ip_restriction.value.virtual_network_subnet_id
        description               = ip_restriction.value.description

        dynamic "headers" {
          for_each = ip_restriction.value.headers != null ? [ip_restriction.value.headers] : []

          content {
            x_azure_fdid      = headers.value.x_azure_fdid
            x_fd_health_probe = headers.value.x_fd_health_probe
            x_forwarded_for   = headers.value.x_forwarded_for
            x_forwarded_host  = headers.value.x_forwarded_host
          }
        }
      }
    }

    dynamic "scm_ip_restriction" {
      for_each = lookup(
        each.value.site_config, "scm_ip_restrictions", {}
      )

      content {
        action                    = scm_ip_restriction.value.action
        ip_address                = scm_ip_restriction.value.ip_address
        name                      = scm_ip_restriction.value.name
        priority                  = scm_ip_restriction.value.priority
        service_tag               = scm_ip_restriction.value.service_tag
        virtual_network_subnet_id = scm_ip_restriction.value.virtual_network_subnet_id
        description               = scm_ip_restriction.value.description

        dynamic "headers" {
          for_each = scm_ip_restriction.value.headers != null ? [scm_ip_restriction.value.headers] : []

          content {
            x_azure_fdid      = headers.value.x_azure_fdid
            x_fd_health_probe = headers.value.x_fd_health_probe
            x_forwarded_for   = headers.value.x_forwarded_for
            x_forwarded_host  = headers.value.x_forwarded_host
          }
        }
      }
    }
  }

  dynamic "auth_settings" {
    for_each = each.value.auth_settings != null ? [each.value.auth_settings] : []

    content {
      enabled                        = auth_settings.value.enabled
      additional_login_parameters    = auth_settings.value.additional_login_parameters
      allowed_external_redirect_urls = auth_settings.value.allowed_external_redirect_urls
      default_provider               = auth_settings.value.default_provider
      issuer                         = auth_settings.value.issuer
      runtime_version                = auth_settings.value.runtime_version
      token_refresh_extension_hours  = auth_settings.value.token_refresh_extension_hours
      token_store_enabled            = auth_settings.value.token_store_enabled
      unauthenticated_client_action  = auth_settings.value.unauthenticated_client_action

      dynamic "active_directory" {
        for_each = auth_settings.value.active_directory != null ? [auth_settings.value.active_directory] : []

        content {
          client_id                  = active_directory.value.client_id
          allowed_audiences          = active_directory.value.allowed_audiences
          client_secret              = active_directory.value.client_secret
          client_secret_setting_name = active_directory.value.client_secret_setting_name
        }
      }

      dynamic "facebook" {
        for_each = auth_settings.value.facebook != null ? [auth_settings.value.facebook] : []

        content {
          app_id                  = facebook.value.app_id
          app_secret              = facebook.value.app_secret
          app_secret_setting_name = facebook.value.app_secret_setting_name
          oauth_scopes            = facebook.value.oauth_scopes
        }
      }

      dynamic "github" {
        for_each = auth_settings.value.github != null ? [auth_settings.value.github] : []

        content {
          client_id                  = github.value.client_id
          client_secret              = github.value.client_secret
          client_secret_setting_name = github.value.client_secret_setting_name
          oauth_scopes               = github.value.oauth_scopes
        }
      }

      dynamic "google" {
        for_each = auth_settings.value.google != null ? [auth_settings.value.google] : []

        content {
          client_id                  = google.value.client_id
          client_secret              = google.value.client_secret
          client_secret_setting_name = google.value.client_secret_setting_name
          oauth_scopes               = google.value.oauth_scopes
        }
      }

      dynamic "microsoft" {
        for_each = auth_settings.value.microsoft != null ? [auth_settings.value.microsoft] : []

        content {
          client_id                  = microsoft.value.client_id
          client_secret              = microsoft.value.client_secret
          client_secret_setting_name = microsoft.value.client_secret_setting_name
          oauth_scopes               = microsoft.value.oauth_scopes
        }
      }

      dynamic "twitter" {
        for_each = auth_settings.value.twitter != null ? [auth_settings.value.twitter] : []

        content {
          consumer_key                 = twitter.value.consumer_key
          consumer_secret              = twitter.value.consumer_secret
          consumer_secret_setting_name = twitter.value.consumer_secret_setting_name
        }
      }
    }
  }

  dynamic "auth_settings_v2" {
    for_each = each.value.auth_settings_v2 != null ? [each.value.auth_settings_v2] : []

    content {
      auth_enabled                            = auth_settings_v2.value.auth_enabled
      runtime_version                         = auth_settings_v2.value.runtime_version
      config_file_path                        = auth_settings_v2.value.config_file_path
      require_authentication                  = auth_settings_v2.value.require_authentication
      unauthenticated_action                  = auth_settings_v2.value.unauthenticated_action
      default_provider                        = auth_settings_v2.value.default_provider
      excluded_paths                          = auth_settings_v2.value.excluded_paths
      require_https                           = auth_settings_v2.value.require_https
      http_route_api_prefix                   = auth_settings_v2.value.http_route_api_prefix
      forward_proxy_convention                = auth_settings_v2.value.forward_proxy_convention
      forward_proxy_custom_host_header_name   = auth_settings_v2.value.forward_proxy_custom_host_header_name
      forward_proxy_custom_scheme_header_name = auth_settings_v2.value.forward_proxy_custom_scheme_header_name

      dynamic "login" {
        for_each = auth_settings_v2.value.login != null ? [auth_settings_v2.value.login] : []

        content {
          logout_endpoint                   = login.value.logout_endpoint
          token_store_enabled               = login.value.token_store_enabled
          token_refresh_extension_time      = login.value.token_refresh_extension_time
          token_store_path                  = login.value.token_store_path
          token_store_sas_setting_name      = login.value.token_store_sas_setting_name
          preserve_url_fragments_for_logins = login.value.preserve_url_fragments_for_logins
          allowed_external_redirect_urls    = login.value.allowed_external_redirect_urls
          cookie_expiration_convention      = login.value.cookie_expiration_convention
          cookie_expiration_time            = login.value.cookie_expiration_time
          validate_nonce                    = login.value.validate_nonce
          nonce_expiration_time             = login.value.nonce_expiration_time
        }
      }

      dynamic "apple_v2" {
        for_each = auth_settings_v2.value.apple_v2 != null ? [auth_settings_v2.value.apple_v2] : []

        content {
          client_id                  = apple_v2.value.client_id
          client_secret_setting_name = apple_v2.value.client_secret_setting_name
          login_scopes               = apple_v2.value.login_scopes

        }
      }

      dynamic "active_directory_v2" {
        for_each = auth_settings_v2.value.active_directory_v2 != null ? [auth_settings_v2.value.active_directory_v2] : []

        content {
          client_id                            = active_directory_v2.value.client_id
          tenant_auth_endpoint                 = active_directory_v2.value.tenant_auth_endpoint
          client_secret_setting_name           = active_directory_v2.value.client_secret_setting_name
          client_secret_certificate_thumbprint = active_directory_v2.value.client_secret_certificate_thumbprint
          jwt_allowed_groups                   = active_directory_v2.value.jwt_allowed_groups
          jwt_allowed_client_applications      = active_directory_v2.value.jwt_allowed_client_applications
          www_authentication_disabled          = active_directory_v2.value.www_authentication_disabled
          allowed_applications                 = active_directory_v2.value.allowed_applications
          allowed_audiences                    = active_directory_v2.value.allowed_audiences
          allowed_groups                       = active_directory_v2.value.allowed_groups
          allowed_identities                   = active_directory_v2.value.allowed_identities
          login_parameters                     = active_directory_v2.value.login_parameters
        }
      }

      dynamic "azure_static_web_app_v2" {
        for_each = auth_settings_v2.value.azure_static_web_app_v2 != null ? [auth_settings_v2.value.azure_static_web_app_v2] : []

        content {
          client_id = azure_static_web_app_v2.value.client_id
        }
      }

      dynamic "custom_oidc_v2" {
        for_each = auth_settings_v2.value.custom_oidc_v2 != null ? auth_settings_v2.value.custom_oidc_v2 : {}

        content {
          name                          = custom_oidc_v2.value.name
          client_id                     = custom_oidc_v2.value.client_id
          openid_configuration_endpoint = custom_oidc_v2.value.openid_configuration_endpoint
          name_claim_type               = custom_oidc_v2.value.name_claim_type
          scopes                        = custom_oidc_v2.value.scopes
          client_credential_method      = custom_oidc_v2.value.client_credential_method
          client_secret_setting_name    = custom_oidc_v2.value.client_secret_setting_name
          authorisation_endpoint        = custom_oidc_v2.value.authorisation_endpoint
          token_endpoint                = custom_oidc_v2.value.token_endpoint
          issuer_endpoint               = custom_oidc_v2.value.issuer_endpoint
          certification_uri             = custom_oidc_v2.value.certification_uri
        }
      }

      dynamic "facebook_v2" {
        for_each = auth_settings_v2.value.facebook_v2 != null ? [auth_settings_v2.value.facebook_v2] : []

        content {
          app_id                  = facebook_v2.value.app_id
          app_secret_setting_name = facebook_v2.value.app_secret_setting_name
          graph_api_version       = facebook_v2.value.graph_api_version
          login_scopes            = facebook_v2.value.login_scopes
        }
      }

      dynamic "github_v2" {
        for_each = auth_settings_v2.value.github_v2 != null ? [auth_settings_v2.value.github_v2] : []

        content {
          client_id                  = github_v2.value.client_id
          client_secret_setting_name = github_v2.value.client_secret_setting_name
          login_scopes               = github_v2.value.login_scopes
        }
      }

      dynamic "google_v2" {
        for_each = auth_settings_v2.value.google_v2 != null ? [auth_settings_v2.value.google_v2] : []

        content {
          client_id                  = google_v2.value.client_id
          client_secret_setting_name = google_v2.value.client_secret_setting_name
          allowed_audiences          = google_v2.value.allowed_audiences
          login_scopes               = google_v2.value.login_scopes
        }
      }

      dynamic "microsoft_v2" {
        for_each = auth_settings_v2.value.microsoft_v2 != null ? [auth_settings_v2.value.microsoft_v2] : []

        content {
          client_id                  = microsoft_v2.value.client_id
          client_secret_setting_name = microsoft_v2.value.client_secret_setting_name
          allowed_audiences          = microsoft_v2.value.allowed_audiences
          login_scopes               = microsoft_v2.value.login_scopes
        }
      }

      dynamic "twitter_v2" {
        for_each = auth_settings_v2.value.twitter_v2 != null ? [auth_settings_v2.value.twitter_v2] : []

        content {
          consumer_key                 = twitter_v2.value.consumer_key
          consumer_secret_setting_name = twitter_v2.value.consumer_secret_setting_name
        }
      }
    }
  }

  dynamic "backup" {
    for_each = each.value.backup != null ? [each.value.backup] : []

    content {
      enabled             = backup.value.enabled
      name                = backup.value.name
      storage_account_url = backup.value.storage_account_url

      dynamic "schedule" {
        for_each = backup.value.schedule != null ? [backup.value.schedule] : []

        content {
          frequency_interval       = schedule.value.frequency_interval
          frequency_unit           = schedule.value.frequency_unit
          keep_at_least_one_backup = schedule.value.keep_at_least_one_backup
          retention_period_days    = schedule.value.retention_period_days
          start_time               = schedule.value.start_time
        }
      }
    }
  }

  dynamic "connection_string" {
    for_each = lookup(
      each.value, "connection_strings", {}
    )

    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  dynamic "identity" {
    for_each = each.value.identity != null ? [each.value.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "logs" {
    for_each = each.value.logs != null ? [each.value.logs] : []

    content {
      detailed_error_messages = logs.value.detailed_error_messages
      failed_request_tracing  = logs.value.failed_request_tracing

      dynamic "application_logs" {
        for_each = logs.value.application_logs != null ? [logs.value.application_logs] : []

        content {
          file_system_level = application_logs.value.file_system_level

          dynamic "azure_blob_storage" {
            for_each = application_logs.value.azure_blob_storage != null ? [application_logs.value.azure_blob_storage] : []

            content {
              level             = azure_blob_storage.value.level
              sas_url           = azure_blob_storage.value.sas_url
              retention_in_days = azure_blob_storage.value.retention_in_days
            }
          }
        }
      }

      dynamic "http_logs" {
        for_each = each.value.logs.http_logs != null ? [each.value.logs.http_logs] : []

        content {
          dynamic "azure_blob_storage" {
            for_each = http_logs.value.azure_blob_storage != null ? [http_logs.value.azure_blob_storage] : []

            content {
              sas_url           = azure_blob_storage.value.sas_url
              retention_in_days = azure_blob_storage.value.retention_in_days
            }
          }

          dynamic "file_system" {
            for_each = http_logs.value.file_system != null ? [http_logs.value.file_system] : []

            content {
              retention_in_days = file_system.value.retention_in_days
              retention_in_mb   = file_system.value.retention_in_mb
            }
          }
        }
      }
    }
  }

  dynamic "storage_account" {
    for_each = lookup(
      each.value, "storage_accounts", {}
    )

    content {
      name = lookup(
        storage_account.value, "name", storage_account.key
      )

      type         = storage_account.value.type
      share_name   = storage_account.value.share_name
      access_key   = storage_account.value.access_key
      account_name = storage_account.value.account_name
      mount_path   = storage_account.value.mount_path
    }
  }
}
