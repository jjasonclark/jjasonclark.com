# Blog at JJasonClark.com

Website for [JJasonClark.com](https://JJasonClark.com)

## Developer Setup

Install Docker

## Build and deploy instructions

1. `make hugo`
2. `make awsdeploy`

## Initial Setup

The terraform backend needs a one time setup using the following commands.

    make awsinit

## Resources

* DynamoDB table for Terraform
* S3 bucket for Terraform
* S3 bucket for static website