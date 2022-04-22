#RH EC2 instance in public subnet 2
resource "aws_instance" "Sub2_instance" {
  ami                     = "ami-0b28dfc7adc325ef4"
  instance_type           = "t2.micro"
  key_name                = "blake_coalfire"
  security_groups         = ["sg-075031f8a996a9c4c"]
  subnet_id               = "subnet-0c1a713153d20f618"
  tags = {
    Name        = var.project
    Description = "Pub Sub 2 Red Hat"
  }
}
