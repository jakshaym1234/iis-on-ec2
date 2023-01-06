# Hosting Windows IIS on EC2

## Architecture:

![image](https://user-images.githubusercontent.com/55613494/211007684-4889c5a3-06f8-4f0a-9b27-ec37e32904d4.png)

## Thoughts behind:

### - Keeping the Solution Secure 
      Putting in correct Network Control
      Allowing Traffic on Described Ports only
      ALB with Cert (WAF for the furture)
      Security Groups to Allow Correct Network Flow
      
### - Keeping it Failure/Fault Resistent
      Deploying to 2 different Availibity Zones
      Having Health Checks

### - DevOps enabled
      Having Deployment Pipelines to create Infra
      
## Security Measure Taken

### - Securing DevOps
      No Secrets in Pipelines
      Storing State File Safely
      Secrets stored in Github
      Terraform Best Practices
      
### - Securing Infra
      Putting in correct Network Control
      Allowing Traffic on Described Ports only
      ALB with Cert (WAF for the furture)
      Security Groups to Allow Correct Network Flow
      


