locals {
  # Common tags to be assigned to all resources
  common_tags = merge({
    "Owner"       = var.platform_output.owner
    "Environment" = var.platform_output.environment_type
    },
    var.platform_output.tags
  )

  vm_size         = var.platform_output.environment_type == "prod" ? "Standard_DS3_v2" : "Standard_B1ms"
  lb_sku          = var.platform_output.environment_type == "prod" ? "Standard" : "Basic"
  ssh_connect_key = data.azurerm_key_vault_secret.privatesshkey.value

  #SonarQube creates admin/admin by default, change in UI or DB
  username               = "admin"
  sonarqube_password     = nonsensitive(var.sonarqube_password == "" ? random_password.password.result : var.sonarqube_password)
  mpp_sonarqube_password = var.platform_output.environment_type == "prod" ? "" : local.sonarqube_password
}
