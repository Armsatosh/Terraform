variable "region" {
  description = "Please enter Region to deploy Server"
  default = "eu-central-1"
}

variable "instance_type" {
  description = "Enter Instance type"
  type = string
  default = "t3.micro"
}

variable "allow_ports" {
  description = "List of Ports to open for server"
  default = ["80","443","22","8080"]
}

variable "enable_detailed_monitoring" {
  default = "true"
}