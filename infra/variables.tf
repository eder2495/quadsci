variable "aws_region" {
  type        = string
  description = "Región de AWS"
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Nombre base del proyecto para etiquetas y nombres"
  default     = "quadsci-challenge"
}

variable "environment" {
  type        = string
  description = "Nombre del entorno"
  default     = "dev"
}

variable "vpc_cidr" {
  type        = string
  description = "Bloque CIDR de la VPC"
  default     = "10.20.0.0/16"
}

variable "dev_instance_type" {
  type        = string
  description = "Tipo de instancia EC2 para el entorno de desarrollo"
  default     = "t3.medium"
}

variable "dev_home_volume_size" {
  type        = number
  description = "Tamaño en GB del volumen EBS montado en /home/ec2-user"
  default     = 20
}

variable "container_image_uri" {
  type        = string
  description = "URI de la imagen del contenedor para el servicio ECS Fargate"
  default     = "us-docker.pkg.dev/google-samples/containers/gke/hello-app:1.0"
}