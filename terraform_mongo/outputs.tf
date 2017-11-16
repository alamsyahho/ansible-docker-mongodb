output "private_ip" {
   value = "${formatlist("%v", aws_instance.mongo.*.private_ip)}"
}

output "public_ip" {
   value = "${formatlist("%v", aws_instance.mongo.*.public_ip)}"
}

output "mongo_hostname" {
   value = "${formatlist("%v", aws_route53_record.mongo.*.fqdn)}"
}
