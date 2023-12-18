variable "resource_group_location" {
  type        = string
  default     = "centralindia"
  description = "Location of the resource group."
}


variable "resource_group_name" {
  type        = string
  default     = "ResourceGroup"
  description = "Name of the resource group."
}

 
variable "appserviceplan_name" {
  type        = string
  default     = "ASP_CI_linux"
  description = "name of the app service plan"
}

variable "Webapp_name" {
  type        = string
  default     = "WebApp1"
  description = "name of the webapp"
}