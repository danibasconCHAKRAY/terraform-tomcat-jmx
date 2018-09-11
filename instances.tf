provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "web" {
#  ami = "ami-28e07e50"
  ami = "ami-51537029"
  instance_type = "t2.micro"
  key_name = "danielbascon"
  security_groups = ["${aws_security_group.web.name}"]
  tags {
     Name = "maq2-tf-1"
  }
}

resource "aws_security_group" "web" {
  name = "web"
  description = "Allow web from the internet"
  ingress {
     from_port = 0
     to_port = 0
     protocol = -1
     cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
     from_port = 0
     to_port = 0 
     protocol = -1
     cidr_blocks = ["0.0.0.0/0"]
}
  tags {
     Name = "ssh"
  }
}

resource "aws_eip" "web" {
  instance = "${aws_instance.web.id}"
  vpc = true
}
