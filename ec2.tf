resource "aws_elb" "ec2_apache" {
  name = "terraform-example-elb"

  subnets         = ["${aws_subnet.public_subnet.id}"]
  security_groups = ["${aws_security_group.sg_elb.id}"]
  instances       = ["${aws_instance.ec2_apache.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

resource "aws_key_pair" "auth" {
  key_name = "vineeth_key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}
resource "aws_instance" "ec2_apache" {
  instance_type = "t2.micro"
  connection {
    user = "ec2-user"
    host = "${self.public_ip}"
  }
#  ami = "${lookup(var.aws_amis, var.aws_region)}"
  ami = "ami-0a887e401f7654935"
  key_name = "vineeth_key"
  vpc_security_group_ids = ["${aws_security_group.sg_ec2.id}"]
  subnet_id = "${aws_subnet.public_subnet.id}" 
provisioner "remote-exec" {
    inline = [
      "sudo yum -y update",
      "sudo yum -y install httpd",
      "sudo service httpd start"
     ]
  }
}
