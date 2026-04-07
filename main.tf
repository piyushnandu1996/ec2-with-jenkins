resource "random_string" "uniq" {
  length  = 5
  upper   = false
  special = false
}

resource "aws_security_group" "firewall" {
  name = "terraform-jenkins-pipeline-${random_string.uniq.result}"

  dynamic "ingress" {
    for_each = var.security_group
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "gloabl_server" {
  ami                    = var.ami_id
  instance_type          = "t3.small"
  key_name               = "git"
  vpc_security_group_ids = [aws_security_group.firewall.id]

  root_block_device {
    volume_size           = 24
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = var.instance_name
  }

  lifecycle {
    create_before_destroy = true
  }

  user_data = <<-EOF
        #!/bin/bash

        sudo apt-get update -y

        # Install Java
        sudo apt-get install -y fontconfig openjdk-21-jre

        # Add Jenkins key
        sudo mkdir -p /etc/apt/keyrings
        wget -O /tmp/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
        sudo mv /tmp/jenkins-keyring.asc /etc/apt/keyrings/jenkins-keyring.asc

        # Add Jenkins repo
        echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list

        # Install Jenkins
        sudo apt-get update -y
        sudo apt-get install -y jenkins

        # Start Jenkins
        sudo systemctl enable jenkins
        sudo systemctl start jenkins

    EOF

}