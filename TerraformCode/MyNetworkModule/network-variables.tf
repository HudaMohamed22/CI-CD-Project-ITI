variable vpc_cidr {
  type        = string
  description = "VPC Cidr get from module's user"
}

variable subnets_details {
  type        = list(object({
    name=string,
    cidr=string,
    type=string

  }))

  description = "subnets details get from module's user"
}