# Setup Elasticsearch on AWS EC2 instance with SSL and password authentication enabled.

## Automation Tools Used :

### **Terraform** : 
- Used for provisioning the infrastructure that includes VPC, SG, IGW, RT, Subnets, and EC2 Instance
- Also used to apply ansible playbook via local-exec provisioner

### **Ansbile** :
- Used for ElasticSearch installation and configuration with SSL certs and elastic user password.


## Screenshots :

### Run Terraform Scipt that provisions Infrastructure and Ansible playbook with local-exec provisioner.

![Screenshot (94)](https://user-images.githubusercontent.com/86839948/224552516-2c2bd09b-b778-4e70-8287-2ecdbf2e4727.png)

![Screenshot (93)](https://user-images.githubusercontent.com/86839948/224552781-747ec770-a3cc-46a9-b12e-91599153925d.png)


- ### Access the Elasticsearch API with credentials via secure and encrypted connection over HTTPS

![Screenshot (92)](https://user-images.githubusercontent.com/86839948/224553279-26bafdae-2d40-41d0-b26e-8f57493a7b26.png)

