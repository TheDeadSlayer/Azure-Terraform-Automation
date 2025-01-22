variable "location" {
  type    = string
  default = "canadacentral"
}

variable "resource_group_name" {
  type    = string
  default = "myAppRG"
}

variable "db_server_name" {
  type    = string
  default = "myapp-dbserver"
}

variable "db_admin_username" {
  type    = string
  default = "postgres"
}

variable "db_admin_password" {
  type    = string
}

variable "db_name" {
  type    = string
  default = "employeesdb"
}

variable "acr_name" {
  type    = string
  default = "myappacr123"
}

variable "app_name" {
  type    = string
  default = "NodeJs-Backend-12"
}

variable "fe_app_name" {
  type    = string
  default = "ReactJs-Frontend-12"
}

variable "image_name" {
  type    = string
  default = "my-backend-image"
}

variable "org_url" {
  type    = string
  default = "MyExistingProject"
}

variable "pat" {
  type    = string
  default = "MyExistingProject"
}


variable "pname" {
  type    = string
  default = "MyExistingProject"
}

variable "azure_subscription_id" {
    type    = string
    default = "id"
}

variable "terraform_service_principal_id" {
  description = "The Object ID of the Service Principal running Terraform"
  default = "terrform-admin12"
}
