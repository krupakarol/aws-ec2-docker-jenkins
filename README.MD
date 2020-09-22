# Deploy dockerized jenkins on EC2

An example of how to create and configure AWS EC2 instance using Terraform, and deploy dockerized Jenkins using ansible. 


# Prerequisites

 - configured AWS profile
 - Terraform v0.13.3
 - Python3


## Terraform script
Terraform script `./terraform/aws-ec2.tf` contains:

 - security group `jenkinsport` which opens port 8765 to the internet
 - security group `allowssh`which opens port 22 to the internet
 - security group `allowhttp` which opens ports 80 and 443 to the internet
 - aws instance which uses AMI-UBUNTU, and t2.micro instance type
 
 All security groups use tag `jenkins` so they will by automatically applied to aws instance.

To make this plan working you need to edit `./terraform/aws-ec2.tf` and set your own AWS settings.
    
    provider  "aws" {
        profile =  "your_aws_profile"
        region =  "aws_region"(if you don't have it configured in your AWS profile)
    }
And set your aws key name.

    resource "aws_instance" "ec2_terraform" {
    //AMI - UBUNTU
    ami = "ami-092391a11f8aa4b7b"
    instance_type = "t2.micro"
    key_name = "aws-key-pair-name"

## Ansible roles

 1. **ubuntu.bootstrap** Which checks if our OS and all installed packages are up-to-date.  It also install latest python3 on host.
 2. **geerlingguy.pip** Jeff's Geerling role which installs latest pip.
 3. **geerlingguy.docker** Jeff's Geerling role which installs latest docker and docker-compose.
 4. **jenkins.docker** Role used to build and Jenkins docker. Default vars are stored in `./roles/jenkins.docker/defaults/main.yml` You must set your own **jenkins_user** and **jenkins_password**  

## Repo workflow

I used `Makefile` to automate the process. In order to accomplish fully worked EC2 instance with running Jenkins you must:

 - configure AWS setting in `aws-ec2.tf`
 - set jenkins user and password in `./roles/jenkins.docker/defaults/main.yml`
 - run `make init` that will download Jeef's Geerling roles
 - run `make devops-init` that will create python3 virtual environment and install all requirements
 - run `make tf-init` that will initialize Terrafom environment 
 - run `make tf-apply` that will apply `aws-ec2.tf` plan
 - run `make run-aws-jenkins` that will play the `jenkins.yml` playbook on your EC2 instance using dynamic inventory `jenkins-aws_ec2.yml`

That's it :)
If you wish to delete AWS security groups, and created instance just simply run `make tf-delete`


