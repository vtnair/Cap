output "address" {
  value = "${aws_elb.ec2_apache.dns_name}"
}
