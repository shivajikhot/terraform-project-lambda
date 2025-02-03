terraform {
  backend "s3" {
    bucket         = "terraform-backend-statefil"  
    key            = "lambda/development/terraform.tfstate"
    region         = "us-east-1"            
    encrypt        = true
  }
}
