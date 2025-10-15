output "instance" {
  description = "contains all web app configuration"
  value       = var.instance.type == "linux" ? try(azurerm_linux_web_app.linux[var.instance.name], null) : try(azurerm_windows_web_app.windows[var.instance.name], null)
}

output "slots" {
  description = "contains all web app slot configurations"
  value       = var.instance.type == "linux" ? azurerm_linux_web_app_slot.linux : azurerm_windows_web_app_slot.windows
}
