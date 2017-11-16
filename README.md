# AWS EC2 provisioning by using Terraform

###### 1. Update terraform variables
There are several variable that you might need to update in `variables.tf` based on your local environment setup
a. `public_key_path` set this to your public key path
b. `key_name` unique key pair identifier name
c. `domain` private hosted domain for internal hostname
d. `instance_type` set to the instance_type that you will use to run the instance
e. `num_instances` number of the instances that will be provision by terraform

###### 2. Configure AWS access and secret key
Before we start, you have to configure the aws secret key and access key inside secret.tf
```
variable "aws_access_key" {
  description = "AWS access key."
  default	= "YourAccessKey"
}

variable "aws_secret_key" {
  description = "AWS secret key."
  default     = "YourSecretKey"
}
```

##### 3. Init terraform working directory
All the terraform provisioning script are put inside terraform_mongo, so when you run the terraform command you will need to specify `terraform_mongo`

Run the command below in order to automatically detect the required plugins and have the plugins installed:
```
# terraform init terraform_mongo
```

##### 4. Run terraform!!!!
Use terraform apply to run all the provisioning
```
# terraform apply terraform_mongo
```

When the instances provisioning are completed, you will see such output displayed on your screen:
```
Apply complete! Resources: 21 added, 0 changed, 0 destroyed.

Outputs:

mongo_hostname = [
    mongo1.test.com,
    mongo2.test.com,
    mongo3.test.com
]
private_ip = [
    10.10.1.152,
    10.10.1.60,
    10.10.1.77
]
public_ip = [
    34.227.206.126,
    54.197.27.34,
    54.82.240.171
]
```

Please take note of the `mongo_hostname` and `public_ip` since this two information will be the one used for ansible deployment later on. So we can easily summarize the output as shown below:
```
mongo1.test.com         34.227.206.126
mongo2.test.com         54.197.27.34
mongo3.test.com         54.82.240.171
```

# Mongodb deployment using Ansible and Docker
##### 1. Update ansible inventory
Update ansible inventory to use the correct ansible_host and make sure the FQDN also match the IP address
```
[mongo-servers]
mongo1.test.com   ansible_host=34.227.206.126
mongo2.test.com   ansible_host=54.197.27.34
mongo3.test.com   ansible_host=54.82.240.171
```

##### 2. Run ansible playbook
Use the command below to run the ansible playbook. This playbook will install mongodb on top of docker and setup the mongodb replica set
```
# ansible-playbook -i hosts deploy_mongo.yml
```

##### 3. That's it!!! Now you have all your mongodb running in clustered replica set

### Known Issues and Future Improvement:
1. Sharding configuration by ansible
2. Currently this ansible roles can't handle additional instance provisioning. Would be nice if it can have the feature to scale out in case need to add more nodes
3. Store terraform state in AWS S3
