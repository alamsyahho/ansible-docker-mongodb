resource "aws_instance" "mongo" {

  connection {
    user = "centos"
  }

  instance_type = "${var.instance_type}"
  count = "${var.num_instances}"

  tags {
    Name = "mongo${count.index + 1}"
  }

  root_block_device {
    delete_on_termination = true
  }

  ami = "${lookup(var.aws_amis, var.aws_region)}"

  key_name = "${aws_key_pair.auth.id}"

  vpc_security_group_ids = ["${aws_default_security_group.default.id}","${aws_security_group.default.id}"]

  subnet_id = "${aws_subnet.my_subnet.0.id}"

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = 1000
    volume_type = "gp2"
    delete_on_termination = true
  }

  provisioner "local-exec" {
    command = "sleep 60; ANSIBLE_HOST_KEY_CHECKING=False ansible all -i ${self.public_ip}, -m hostname -a 'name=${self.tags.Name}.${aws_route53_zone.default.name}' -b -u centos"
  }

}
