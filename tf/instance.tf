resource "aws_instance" "example" {
  ami = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"
  
  key_name = aws_key_pair.mykeypair.key_name

  subnet_id = aws_subnet.main-public-1.id

  vpc_security_group_ids = [aws_security_group.allow-ssh.id]

}
