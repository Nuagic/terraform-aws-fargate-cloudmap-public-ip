variable "name" {
  description = "Name"
  type        = string
}

variable "ecs_cluster_arn" {
  description = "ECS cluster ARN"
  type        = string
}

variable "ecs_service_name" {
  description = "ECS service name"
  type        = string
}


variable "cloudmap_service_id" {
  description = "Cloudmap service ID"
  type        = string
}

variable "cloudmap_instance_id" {
  description = "Cloudmap instance ID"
  type        = string
  default     = "default"
}

variable "tags" {
  description = "Tags map"
  type        = map(string)
  default     = {}
}

