terraform {
  backend "s3" {
    bucket  = "my-tf-state-999"
    encrypt = true
    key     = "tf/iis-on-ec2/terraform.tfstate"
    region  = "us-west-2"
  }
}