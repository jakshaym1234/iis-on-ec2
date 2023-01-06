# Hosting Windows IIS on EC2
## General Impression?

## Architecture:

![image](https://user-images.githubusercontent.com/55613494/211007684-4889c5a3-06f8-4f0a-9b27-ec37e32904d4.png)

## Thoughts behind:

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
      


