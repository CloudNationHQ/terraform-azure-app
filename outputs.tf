output "instance" {
  description = "contains all web app configuration"
  value       = var.instance.type == "linux" ? try(azurerm_linux_web_app.linux[var.instance.name], null) : try(azurerm_windows_web_app.windows[var.instance.name], null)
}

output "slot" {
  description = "contains all web app slot configuration"
  value       = var.instance.type == "linux" ? try(azurerm_linux_web_app_slot.linux[var.instance.name], null) : try(azurerm_windows_web_app_slot.windows[var.instance.name], null)
}

# output "user_assigned_identities" {
#   description = "contains all user assigned identities configuration"
#   value       = azurerm_user_assigned_identity.identity
# }
