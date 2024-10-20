data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    organization = "hellocloud-eem"
    workspaces = {
      name = "create-vpc-day3"
    }
  }
}

data "terraform_remote_state" "iam" {
  backend = "remote"
  config = {
    organization = "hellocloud-eem"
    workspaces = {
      name = "enable-aws-auth-on-vault-day6"
    }
  }
}

data "terraform_remote_state" "vault_cluster" {
  backend = "remote"
  config = {
    organization = "hellocloud-eem"
    workspaces = {
      name = "vault-cluster-day1"
    }
  }
}


data "terraform_remote_state" "approle" {
  backend = "remote"
  config = {
    organization = "hellocloud-eem"
    workspaces = {
      name = "create-approle-day7"
    }
  }
}


data "aws_vpc" "selected" {
  id = data.terraform_remote_state.vpc.outputs.vpc_id
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.terraform_remote_state.vpc.outputs.vpc_id]
  }

  tags = {
    Name = "public*"
  }
}

data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}

#private 
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.terraform_remote_state.vpc.outputs.vpc_id]
  }

  tags = {
    Name = "private*"
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}