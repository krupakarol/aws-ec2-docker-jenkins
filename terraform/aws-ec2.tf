provider "aws" {
    profile = "aws-profile"
    region = "eu-central-1"
}

resource "aws_security_group" "jenkinsport" {
  name        = "jenkins-port"
  description = "Open port for jenkins"

  ingress {
    description = "jenkins-8765"
    from_port   = 8765
    to_port     = 8765
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins"
  }
}

resource "aws_security_group" "allowssh" {
  name        = "allow-ssh"
  description = "Allow HTTP, HTTPS and SSH traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins"
  }
}

resource "aws_security_group" "allowhttp"{
  name        = "allow-http"
  description = "Allow HTTP, HTTPS traffic"

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins"
  }
}


resource "aws_instance" "ec2_terraform" {
//AMI - UBUNTU
    ami = "ami-092391a11f8aa4b7b"
    instance_type = "t2.micro"
    key_name = "aws-key-pair-name"
    tags = {
      Name = "jenkins"
    }

    vpc_security_group_ids = [
      aws_security_group.allowssh.id,
      aws_security_group.allowhttp.id,
      aws_security_group.jenkinsport.id
  ]
}