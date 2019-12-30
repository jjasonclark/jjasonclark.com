# Blog at JJasonClark.com

![Build Status](https://codebuild.us-east-1.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiVC9CZzNHR0J2b05kK2ZoQy8wSnJ0RVNidXYyWTE2QXI0TkNWVGhhTFJlLzRpUm1yeEZVY2poNk1WbEloanZQdGU4SDBqT1VNU2hHc1BlQTB3cGFvUk1RPSIsIml2UGFyYW1ldGVyU3BlYyI6IkMwS0hpWFRZMURZK21ENVgiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)

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