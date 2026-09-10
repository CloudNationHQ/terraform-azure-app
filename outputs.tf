output "web_app" {
  description = "contains all web app configuration"
  value       = var.web_app.type == "linux" ? try(azurerm_linux_web_app.this["app"], null) : try(azurerm_windows_web_app.this["app"], null)
  sensitive   = true
}

output "slots" {
  description = "contains all web app slot configurations"
  value       = var.web_app.type == "linux" ? azurerm_linux_web_app_slot.this : azurerm_windows_web_app_slot.this
  sensitive   = true
}
