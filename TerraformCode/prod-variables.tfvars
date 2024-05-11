vpc_cidr="192.168.0.0/16"

region="us-east-1"

subnets_details=[

{
    name="public",
    cidr="192.168.1.0/24",
    type="public"
},
{
    name="public2",
    cidr="192.168.2.0/24",
    type="public"
},
{
    name="private1",
    cidr="192.168.3.0/24",
    type="public"
},
{
    name="private2",
    cidr="192.168.4.0/24",
    type="private"
},


]

variable ec2_details {

{
    type="ami-04e5276ebb8451442",
    ami="t2.micro",
    key_name="tf-key-pair",
}


}