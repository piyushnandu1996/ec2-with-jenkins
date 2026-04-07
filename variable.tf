variable "ami_id" {
  description = "mention ami id for instance"
  type        = string
  default     = "ami-05d2d839d4f73aafb"
}

variable "security_group" {
  description = "mention all ports for firewall incoming"
  type        = list(string)
  default     = ["22", "80", "443", "8080", "8082"]
}

variable "instance_name" {
  description = "mention server name"
  type        = string
  default     = "pipeline"
}

variable "aws_access_key" {
    description = "mention access key of aws"
    type = string
    default = ""
}

variable "aws_secret_key" {
    description = "aws secrete key"
    type = string
    default = ""
}

variable "aws_region" {
    type = string
    default = "ap-south-1"
  
}