resource "aws_instance" "test-server" {
  ami = "ami-02d26659fd82cf299"
  instance_type = "t2.micro"
  key_name = "mykey"
  vpc_security_group_ids = ["sg-0e572ed58dbc9ec7c"]
  connection {
     type = "ssh"
     user = "ubuntu"
     private_key = file("./mykey.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/finance-project/terraform-files/ansibleplaybook.yml"
     }
  }
