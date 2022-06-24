resource "aws_network_interface" "mongo_1" {
  subnet_id   = aws_subnet.my_subnet.id

  tags = {
    Name = "primary_network_interface_mongo_1"
  }
}

resource "aws_instance" "foo" {
  ami           = "ami-005e54dee72cc1d00" # us-west-2
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}