terraform {
  backend "s3" {
    bucket = "tf-bucket-huda"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "tf-lock-table"
  }
}