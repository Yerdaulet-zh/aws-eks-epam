variable "project_name" {
  description = "project name"
  type        = string
}

variable "region" {
  description = "region"
  type        = string
}

variable "vpc_cidr" {
  description = "vpc cidr block"
  type        = string
}

variable "subnets" {
  description = "private, public and storage related subnets"

  type = map(object({
    cidr   = string
    az     = string
    public = bool
    usage  = string
  }))
}

