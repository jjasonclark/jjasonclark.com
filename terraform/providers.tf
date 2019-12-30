provider "aws" {
  version = "=2.43.0"
  region  = "us-east-1"
}

provider "aws" {
  version = "=2.43.0"
  region  = "us-east-1"
  alias   = "us-east-1"
}

terraform {
  backend "s3" {
    dynamodb_table = "jason-blog-terraform"
    bucket         = "jason-blog-terraform"
    key            = "jason-blog.tfstate"
    region         = "us-east-1"
    encrypt        = false
  }
}
