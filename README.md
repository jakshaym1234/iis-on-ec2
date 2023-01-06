# Hosting Windows IIS on EC2
## General Impression?
   1. Good Test of AWS
   2. Good Test of Networking
   3. Good Test if IaC Terraform
   4. Good Test of Secure Architecture
   5. Good Test of DevOps Enablement
   6. Good Test of Scritping Skills
  
## Architecture:

![image](https://user-images.githubusercontent.com/55613494/211007684-4889c5a3-06f8-4f0a-9b27-ec37e32904d4.png)

## Thoughts behind and Approach?

### - Keeping the Solution Secure 
      1. Putting in correct Network Control
      2. Allowing Traffic on Described Ports only
      3. ALB with Cert (WAF for the furture)
      4. Security Groups to Allow Correct Network Flow
      
### - Keeping it Failure/Fault Resistent
      1. Deploying to 2 different Availibity Zones
      2. Having Health Checks

### - DevOps enabled
      1. Having Deployment Pipelines to create Infra
      2. Having Pipeline to clean up Infra
      3, Having Setup of the IIS servers automated via "userdata" in EC2
      
## Security Measure Taken

### - Securing DevOps
      1. No Secrets in Pipelines
      2. Storing State File Safely
      3. Secrets stored in Github
      4. Terraform Best Practices
      
### - Securing Infra
      1. Putting in correct Network Control
      2. Allowing Traffic on Described Ports only
      3. ALB with Cert (WAF for the furture)
      4. Security Groups to Allow Correct Network Flow
      
## Improvements:

   1. WAF for ALB
   2. Better way for config management of servers e.g. Ansible, Packer
   3. Post Deploy Testing

