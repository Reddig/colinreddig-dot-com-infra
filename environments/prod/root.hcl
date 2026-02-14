inputs = {
    env = "prod"
    account_id = "009299048044"
    assume_role_name = "terraform"
    domain_name = "colinreddig.com"
}

remote_state {
  backend = "s3"
  generate = {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket         = "prod-colinreddig-dot-com-terraform-state-management"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile = true
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
    provider "aws" {
      region = "us-east-1"
      assume_role {
        role_arn = "arn:aws:iam::$${var.account_id}:role/$${var.assume_role_name}"
      }
    }
EOF
}

generate "default_vars" {
    path = "default_vars.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
    variable "env" {
        type = string
    }

    variable "account_id" {
    type = string
    }

    variable "assume_role_name" {
    type = string
    }

    variable "domain_name" {
    type = string
    }
EOF
}
