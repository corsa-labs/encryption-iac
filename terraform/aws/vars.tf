variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  type        = string
}

variable "ami_owner" {
  description = "The owner of the AMI"
  type        = string
  default     = "324011078465"
}

variable "key_name" {
  description = "The name of the key pair"
  type        = string
  default     = "bastion-ssh-key"
}

variable "package_name" {
  description = "The package name, defaults to corsa-pii if PACKAGE_VERSION is not set"
  type        = string
  default     = "corsa-pii"
}

variable corsa_jwks {
  description = "JWT key service url"
  type = string
  default = "https://jwks.corsa.finance/" # us
  # eu https://jwks.eu.corsa.finance/
}

variable "auth0_audience" {
  description = "auth0 jwt audience"
  type = string
  default = "EfoTQJf4D14Mkuqhmn46OtvtcC16otdA" # us
  # eu WnbMDmVcPqiQzNf9iDKx8042z8JAsUcN
}

variable "cidr" {
  description = "subnet cidr"
  type = string
}

variable "zone" {
  description = "availability zone"
  type = string
  default = "us-east-1a"
}
