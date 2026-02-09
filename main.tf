terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 1. Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-quality-gate-demo"
  location = "East US"
  tags = {
    Environment = "Dev"
    Project     = "QualityGate"
  }
}

# 2. App Service Plan (The compute)
resource "azurerm_service_plan" "plan" {
  name                = "plan-quality-gate"
  location            = "East US"
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

# 3. The Web App (Production)
resource "azurerm_linux_web_app" "app" {
  name                = "app-quality-gate-prod"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.plan.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    # This tells Azure to look for a Python app
    application_stack {
      python_version = "3.9"
    }
    # Command to start FastAPI or Flask
    app_command_line = "gunicorn -w 4 -k uvicorn.workers.UvicornWorker main:app"
  }

  app_settings = {
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "true"
    "WEBSITES_PORT"                  = "8000"
  }
}

# 4. The Staging Slot (The QE "Safety Net")
# This is where your automated tests run against REAL infrastructure
# before you swap to Production.
resource "azurerm_linux_web_app_slot" "staging" {
  name           = "staging"
  app_service_id = azurerm_linux_web_app.app.id

  site_config {
    application_stack {
      python_version = "3.9"
    }
  }
}

# 5. Output the URLs for your test scripts to consume
output "production_url" {
  value = azurerm_linux_web_app.app.default_hostname
}

output "staging_url" {
  value = azurerm_linux_web_app_slot.staging.default_hostname
}
