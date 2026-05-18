resource "azurerm_container_app" "ca" {
  name                         = var.container_app_name
  container_app_environment_id = var.container_app_env_id
  resource_group_name          = var.resource_group_name
  revision_mode                = var.revision_mode

  template {
    container {
      name    = var.template.name
      image   = var.template.image
      command = var.template.command
      cpu     = var.template.cpu
      memory  = var.template.memory

      dynamic "env" {
        for_each = var.environment

        content {
          name        = env.key
          value       = env.value.value
          secret_name = env.value.secret_name
        }
      }
    }
    min_replicas = var.template.min_replicas
    max_replicas = var.template.max_replicas
  }

  dynamic "ingress" {
    for_each = var.enable_ingress == true ? [1] : []

    content {
      allow_insecure_connections = var.ingress.allow_insecure_connections
      client_certificate_mode    = var.ingress.client_certificate_mode
      external_enabled           = var.ingress.external_enabled
      target_port                = var.ingress.target_port
      transport                  = var.ingress.transport

      traffic_weight {
        latest_revision = true
        percentage      = 100
      }
    }
  }

  identity {
    type = var.identity_type
  }

  registry {
    identity = var.registry_identity
    server   = var.registry_endpoint
  }

  lifecycle {
    ignore_changes = [
      template[0],
      ingress[0],
      secret
    ]
  }

  tags = var.tags
}