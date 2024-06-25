vpc_cidr="192.168.0.0/16"

region="us-east-1"

subnets_details=[

{
    name="public",
    cidr="192.168.1.0/24",
    type="public",
    availability_zone = "us-east-1a"
},
{
    name="public2",
    cidr="192.168.2.0/24",
    type="public",
    availability_zone = "us-east-1b"

},
{
    name="private1",
    cidr="192.168.3.0/24",
    type="public",
    availability_zone = "us-east-1a"
},
{
    name="private2",
    cidr="192.168.4.0/24",
    type="private",
    availability_zone = "us-east-1b"
},


]

variable ec2_details {

{
    type="ami-04b70fa74e45c3917",
    ami="t2.micro",
    key_name="tf-key-pair",
}


}