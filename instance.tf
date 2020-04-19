provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami             = "ami-085925f297f89fce1" # Ubuntu 18.04
  instance_type   = "${var.instance_type}"
  key_name        = "${aws_key_pair.my_key.key_name}"
  security_groups = ["${aws_security_group.allow_ssh.name}", "${aws_security_group.allow_http.name}", "${aws_security_group.allow_https.name}"]
}

# Add SSH key
resource "aws_key_pair" "my_key" {
  key_name   = "my-key"
  public_key = "${file("${var.public_key}")}"
}

# Configure Security Group Rules
resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_http" {
  name = "allow_http"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_https" {
  name = "allow_https"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "example_public_dns" {
  value = "${aws_instance.example.public_dns}"
}