variable vpc_cidr {
  type        = string
  description = "description"
}

variable subnets_details {
  type        = list(object({
    name=string,
    cidr=string,
    type=string

  }))

  description = "description"
}

variable region {
  type        = string
  description = "description"
}

variable ec2_details {
type        = object({

type=string,
ami=string,
key_name=string,


  })

  description = "description"
}


