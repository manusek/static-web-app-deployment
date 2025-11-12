variable "project_name" {
  description = "Name of project"
  type        = string
  default     = "static-website"
}

variable "environment" {
  description = "Enviroment (dev, staging, prod)"
  type        = string
  default     = "dev"
}
