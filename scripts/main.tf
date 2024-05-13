resource "aws_instance" "test-server" {
  ami           = "ami-07caf09b362be10b8" 
  instance_type = "t2.micro" 
  key_name = "jenkinskey"
  vpc_security_group_ids= ["sg-02ea7c8681f58b6ff"]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("./jenkinskey.pem")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
  }
  tags = {
    Name = "test-server"
  }
  provisioner "local-exec" {
        command = " echo ${aws_instance.test-server.public_ip} > inventory "
  }
   provisioner "local-exec" {
  command = "ansible-playbook /var/lib/jenkins/workspace/Banking/scripts/finance-playbook.yml "
  } 
}
