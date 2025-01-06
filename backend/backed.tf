terraform {
  backend "s3" {

    bucket         = "eks-cluster-terraform-project-6thdec"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"

  }
}