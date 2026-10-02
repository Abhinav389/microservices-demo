variable "project_name" {
    description = "Project name for resource naming and tagging"
    type        = string
    default     = "microservice-demo"
}

variable "vpc_cidr" {
    description = "Cidr block value of cluster"
    type        = string
    default     = "10.0.0.0/16"
}
variable "availability_zones" {
    description = "Value for availability zones"
    type        = list(string)  
    default     = ["us-east-1a", "us-east-1b"]
}
variable "public_subnets_cidr"{
    description = "Public subnet cidr blocks"
    type = list(string)
    default = ["10.0.1.0/24","10.0.2.0/24"]
}
variable "private_subnets_cidr"{
    description = "Private subnet cidr blocks"
    type = list(string)
    default = ["10.0.10.0/24","10.0.20.0/24"]
}
variable "cluster_name"{
    description = "EKS Cluster name for Kubernetes subnet tags"
    type = string
    default = "microservices-demo-cluster"
}