//---------------------------------------------------------
//-Jump Server 
//---------------------------------------------------------

resource "aws_security_group" "allow_ssh_jump" {
  name        = "allow_ssh_jump"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = {
    Name = "allow_ssh_jump"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_jump" {
  security_group_id = aws_security_group.allow_ssh_jump.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_ssh_jump" {
  security_group_id = aws_security_group.allow_ssh_jump.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_instance" "jump" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = "ssh-key-${random_pet.env.id}"
  subnet_id  = data.aws_subnets.public.ids[0]
  vpc_security_group_ids = [aws_security_group.allow_ssh_jump.id]

  tags = {
    Name = "Jump Server"
  }
  lifecycle {
    ignore_changes = [
      ami,
      tags,
    ]
  }
}

//---------------------------------------------------------
//- Application with AWS Auth Method
//---------------------------------------------------------
resource "aws_security_group" "allow_ssh_app" {
  name        = "allow_ssh_app"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = {
    Name = "allow_ssh_app"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_app" {
  for_each         = data.aws_subnet.public
  security_group_id = aws_security_group.allow_ssh_app.id
  cidr_ipv4         = each.value.cidr_block # aws_instance.jump.private_ip
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_ssh_app" {
  security_group_id = aws_security_group.allow_ssh_app.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}



data "template_file" "vault_agent_aws" {
  template = file("${path.module}/template/ec2-aws-auth.tftpl")
  vars = {
    tpl_vault_server_addr = data.terraform_remote_state.vault_cluster.outputs.vault_private_endpoint_url
    MYSQL_HOST = aws_db_instance.project_rds.address
    MYSQL_USER = aws_db_instance.project_rds.username
    MYSQL_PASS = aws_db_instance.project_rds.password
  }
}

resource "aws_instance" "app_aws" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "ssh-key-${random_pet.env.id}"
  subnet_id  = data.aws_subnets.private.ids[0]
  vpc_security_group_ids = [aws_security_group.allow_ssh_app.id]
  iam_instance_profile = data.terraform_remote_state.iam.outputs.instance_profile_id
  user_data = template_file.vault_agent_aws.rendered
  tags = {
    Name = "App1"
  }
  lifecycle {
    ignore_changes = [
      ami,
      tags,
    ]
  }
}

//---------------------------------------------------------
//- Application with Approle Auth Method
//---------------------------------------------------------
data "template_file" "vault_agent_approle" {
  template = file("${path.module}/template/ec2-approle.tftpl")
  vars = {
   tpl_vault_server_addr = data.terraform_remote_state.vault_cluster.outputs.vault_private_endpoint_url
    login_role_id = data.terraform_remote_state.approle.outputs.role_id
    login_secret_id = data.terraform_remote_state.approle.outputs.secret_id
  }
}

resource "aws_instance" "app_approle" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "ssh-key-${random_pet.env.id}"
  subnet_id  = data.aws_subnets.private.ids[1]
  vpc_security_group_ids = [aws_security_group.allow_ssh_app.id]
  user_data = template_file.vault_agent_approle.rendered
  tags = {
    Name = "Approle"
  }
  lifecycle {
    ignore_changes = [
      ami,
      tags,
    ]
  }
}