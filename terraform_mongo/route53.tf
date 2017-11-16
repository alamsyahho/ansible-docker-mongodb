resource "aws_route53_zone" "default" {
  name = "${var.domain}"
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route53_record" "mongo" {
  count = "${var.num_instances}"
  zone_id = "${aws_route53_zone.default.zone_id}"
  name = "mongo${count.index + 1}"
  type = "CNAME"
  ttl = "300"
  records = ["${element(aws_instance.mongo.*.private_dns, count.index)}"]
}
