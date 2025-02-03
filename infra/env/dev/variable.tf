variable "patient_service_image_uri" {
  description = "ECR image URI for Patient Service"
  type        = string
}

variable "appointment_service_image_uri" {
  description = "ECR image URI for Appointment Service"
  type        = string
}

variable "patient_db_url" {
  description = "Database URL for Patient Service"
  type        = string
}

variable "appointment_db_url" {
  description = "Database URL for Appointment Service"
  type        = string
}
