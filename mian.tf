terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# --------------------------
# Provider 1 - Region 1 (Mumbai)
# --------------------------
provider "aws" {
  region = "ap-south-1"
}

# --------------------------
# Provider 2 - Region 2 (US East-1)
# --------------------------
provider "aws" {
  alias  = "useast"
  region = "us-east-1"
}

# --------------------------
# EC2 in Region 1 (Mumbai)
# --------------------------
resource "aws_instance" "server_mumbai" {
  ami           = "ami-02b8269d5e85954ef"   # Ubuntu 22.04 LTS - Mumbai
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install nginx -y
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = {
    Name = "Nginx-Server-Mumbai"
  }
}

# --------------------------
# EC2 in Region 2 (US East-1)
# --------------------------
resource "aws_instance" "server_us_east" {
  provider      = aws.useast
  ami           = "ami-0ecb62995f68bb549"   # Ubuntu 22.04 LTS - US East
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install nginx -y
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = {
    Name = "Nginx-Server-US-East"
  }
}
