terraform {
  backend "s3" {
    encrypt = true
    region  = "us-west-2"
  }
}
