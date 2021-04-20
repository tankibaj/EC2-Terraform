resource "random_pet" "this" {}

resource "aws_security_group" "this" {
  name        = "ec2-${random_pet.this.id}"
  description = "Allow SSH HTTP"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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
    Name = random_pet.this.id
  }
}


resource "aws_instance" "this" {
  count                  = var.instance_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  availability_zone      = element(data.aws_availability_zones.available.names, count.index)
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.this.id]
  user_data              = file("user-data.yml")
  monitoring             = var.monitoring

  tags = {
    Name = random_pet.this.id
    Description = "Terraform"
  }
}
