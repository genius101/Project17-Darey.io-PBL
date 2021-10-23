# AUTOMATE INFRASTRUCTURE WITH IAC USING TERRAFORM. PART 2

Let us continue from where we have stopped in the previous Project 16.

Based on the knowledge from the previous project keep on creating AWS resources!

## Part 1 – Networking

Create 4 private subnets keeping in mind following principles:

- Make sure you use use variables or length() function to determine the number of AZs

- Use variables and cidrsubnet() function to allocate vpc_cidr for subnets

- Keep variables and resources in separate files for better code structure and readability

- Tags all the resources you have created so far. Explore how to use format() and count functions to automatically tag subnets with its respective number.

      tags = merge(
          local.default_tags,
          {
            Name = format("PrivateSubnet-%s", count.index)
          } 
        )
## Part 2 – Internet Gateways & format() function

Create an Internet Gateway in a separate Terraform file internet_gateway.tf

    resource "aws_internet_gateway" "ig" {
      vpc_id = aws_vpc.main.id
      tags = merge(
        local.default_tags,
        {
          Name = format("%s-%s!", aws_vpc.main.id,"IG")
        } 
      )
    }

Did you notice how we have used format() function to dynamically generate a unique name for this resource?

For example, each of our subnets should have a unique name in the tag section. Without the format() function, we would not be able to see uniqueness. With the format function, each private subnet’s tag will look like this.

- Name = PrvateSubnet-0
- Name = PrvateSubnet-1
- Name = PrvateSubnet-2


## Part 3 – NAT Gateways

We will create the NAT Gateways in a new file called natgateway.tf

We need to create the following resource in the natgateway.tf

- Elastic IP for NAT
- NAT Gateway 
- aws_route_table for the following:    
  - Private Subnet A
  - Private Subnet B
- aws_route for the following:
  - Private Subnet A
  - Private Subnet B
- aws_route_table_association for the following:
  - Private Subnet A
  - Private Subnet B


## Part 4 – AWS routes

Create a file called route_tables.tf and use it to create routes for both public and private subnets, create resources for the following:

- aws_route_table
  - Create aws_route_table for Public Subnets: The route table that automatically comes with your VPC. It controls the routing for all subnets that are not explicitly associated with any other route table.
- aws_route
  - Create aws_route for Public Subnets: this is used to determine where network traffic from your subnet or gateway is directed, it requires ID of the routing table
- aws_route_table_association
  - Create aws_route_table_association for Public Subnets: This provides a resource to create an association between a route table and a subnet or a route table and an internet gateway or virtual private gateway.



Now if you run terraform plan and terraform apply it will add the following sources to AWS in multi-az set up:

- aws_route_table
- Our main vpc
- 2 Public subnets
- 4 Private subnets
- 1 Internet Gateways
- 1 NAT Gateways
- 1 EIPs
- 2 Route tables


## Part 5 – AWS Identity and Access Management

We want to pass an IAM role our EC2 instances to give them access to some specific resources, so we need to create the following resource:

- Create AssumeRole For EC2 ( resource "aws_iam_role" )
- Create IAM policy for the IAM role ( resource "aws_iam_policy" )
- Attach the Policy to the IAM Role ( resource "aws_iam_role_policy_attachment" )
- Create an Instance Profile to pass IAM Role to EC2 Instance ( resource "aws_iam_instance_profile" )


## Part 6 – CREATE SECURITY GROUPS

We are going to create all the security groups in a single file, then we are going to refrence this security group within each resources that needs it.

We need to create the following:

- Security Group for Application Load Balancer
  - resource "aws_security_group"
  - resource "aws_security_group_rule"

- Security Group for Autoscaling Group
  - resource "aws_security_group" 
  - resource "aws_security_group_rule"

- Security Group for Bastion Servers
  - resource "aws_security_group" 

- Security Group for Private Servers
  - resource "aws_security_group"
 
- Create Security Group for ELastic File System
  - resource "aws_security_group"

- Create Security Group for MySQL RDS
  - resource "aws_security_group"
  - resource "aws_security_group_rule"


## Part 7 - Craete EC2 Instance for Public and Private Servers

- EC2 Instances in Public Subnets
  - resource "aws_instance"
  - create an additional resource for key pair to be able to log into the EC2 instances - keypair.tf
  - Remember to reference the correct security group and ami for the instance

- EC2 Instances in Private Subnets
  - resource "aws_instance"
  - create an additional resource for key pair to be able to log into the EC2 instances - keypair.tf
  - Remember to reference the correct security group and ami for the instance

## Part 8 - Application Load Balancer (ALB)

Create a file called alb.tf and use it to create an Internal and Exteral(Internet-Facing) Application Load Balancer. 

- External (Internet-facing) Application Load Balancer
  - resource "aws_lb"

- Internal Application Load Balancer
  - resource "aws_lb"

Then we create the target group and create the listener rule for our target groups:

- Public Target Group
  - resource "aws_lb_target_group"

- Listener for Public Target Group
  - resource "aws_lb_listener" 

- Target Group for Private Servers
  - resource "aws_lb_target_group"

- Listener for Private Target Group
  - resource "aws_lb_listener" 


## Part 9 - Print Output to Terminal

Create a file called output.tf and print out output.

The output would be displayed to the terminal once our code runs successfully

![Output End](https://user-images.githubusercontent.com/10243139/138561271-c7dff19a-6c2d-4786-ab69-4090444b55ea.png)


## Part 10 - Auto Scaling Group (ASG)

Create a file called asg.tf and use it to scale the EC2s out and in depending on the application traffic.

- Create a Launch Configuration for ASG
  - resource "aws_launch_configuration"

- You must specify either launch_configuration, launch_template, or mixed_instances_policy when using aws_autoscaling_group.
  - resource "aws_launch_template"
  - Attach user_data = filebase64("userdata.sh") 
    - userdata.sh contains bash script to install, run, enable Apache and echo Terraform in index.html

- Create Auto scaling Group for Public Servers
  - resource "aws_autoscaling_group"

- Create Auto scaling Group for Private Server A
  - resource "aws_autoscaling_group"

- Create Auto scaling Group for Private Server B
  - resource "aws_autoscaling_group"


## Part 11 - STORAGE AND DATABASE

We need to create the following resource:

- Elastic File System (EFS) - efs.tf
  - In order to create an EFS you need to create a KMS key - kms.tf
- AWS Key Management Service (KMS) - kms.tf
- AWS Relational Database Service (RDS) - rds.tf


## Part 12 - Variables.tf

Before Applying, if you take note, we gave refrence to a lot of varibales in our resources that has not been declared in the variables.tf file. Go through the entire code and spot this variables and declare them in the variables.tf file.

At this point, you shall have pretty much all infrastructure elements ready to be deployed automatically

Try to plan and apply your Terraform codes, explore the resources in AWS console and make sure you destroy them right away to avoid massive costs.

## To Confirm the deployed resources, use a command "Terraform state list"

![Active Resources 1](https://user-images.githubusercontent.com/10243139/138561443-3bdfb37a-01c2-4384-a491-2868135e8e01.png)
![Active Resources 2](https://user-images.githubusercontent.com/10243139/138561445-b89d049c-e25a-406e-92a6-009f07ce0598.png)

# Congratulations!

### Now you have fully automated creation of AWS Infrastructure for 2 websites with Terraform.
