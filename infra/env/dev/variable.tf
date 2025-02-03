variable "patient_service_image_uri" {
  description = "ECR image URI for Patient Service"
  type        = string
  default     = "575108922676.dkr.ecr.us-west-1.amazonaws.com/patient-service-repo:latest"
}

variable "appointment_service_image_uri" {
  description = "ECR image URI for Appointment Service"
  type        = string
  default     = "575108922676.dkr.ecr.us-west-1.amazonaws.com/appointment-service-repo:latest"
}

