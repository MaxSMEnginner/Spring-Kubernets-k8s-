terraform {
  backend "s3" {
    bucket = "terraform-states-davinchicoder"
    key    = "spring-k8s-terraform.tfstate"
    region = "eu-west-3"
  }
}
