# **Using Infracost for Cost Estimation**

## **Why Use Infracost?**
Infracost is a powerful tool that provides real-time cost estimation for infrastructure as code (IaC) configurations. It allows for proactive cost management by estimating changes before deployment, helping to maintain budget control and optimize cloud expenses.

## **Benefits of Using Infracost**
- **Cost Visibility:** Estimates the cost of Terraform resources before applying changes.
- **Budget Control:** Helps prevent unexpected cloud expenses by providing cost breakdowns.
- **CI/CD Integration:** Can be integrated into CI/CD pipelines to track cost changes automatically.
- **Multi-Cloud Support:** Supports AWS, Azure, and Google Cloud cost estimation.
- **Historical Cost Tracking:** Compares changes over time to optimize infrastructure expenses.
- **Open-Source & Developer-Friendly:** Easily integrates with Terraform workflows.

## **Example: Infracost Breakdown in a Terraform Project**
The following example demonstrates running `infracost breakdown` on a Terraform project:

```sh
kilo@MacBookPro kooben-final-project-aws-bootcamp (main) % infracost breakdown --path ./infra
INFO Autodetected 1 Terraform project across 1 root module
INFO Found Terraform project main at directory . using Terraform var files terraform.tfvars

Project: main

 Name                                                       Monthly Qty  Unit                    Monthly Cost   
                                                                                                                
 module.myBucket.aws_kms_key.kooben_storage_kms                                                                 
 ├─ Customer master key                                               1  months                         $1.00   
 ├─ Requests                                          Monthly cost depends on usage: $0.03 per 10k requests     
 ├─ ECC GenerateDataKeyPair requests                  Monthly cost depends on usage: $0.10 per 10k requests     
 └─ RSA GenerateDataKeyPair requests                  Monthly cost depends on usage: $0.10 per 10k requests     
                                                                                                                
 module.myBucket.aws_s3_bucket.kooben_storage_bucket                                                             
 └─ Standard                                                                                                    
    ├─ Storage                                        Monthly cost depends on usage: $0.0245 per GB             
    ├─ PUT, COPY, POST, LIST requests                 Monthly cost depends on usage: $0.0054 per 1k requests    
    ├─ GET, SELECT, and all other requests            Monthly cost depends on usage: $0.00043 per 1k requests   
    ├─ Select data scanned                            Monthly cost depends on usage: $0.00225 per GB            
    └─ Select data returned                           Monthly cost depends on usage: $0.0008 per GB             
                                                                                                                
 OVERALL TOTAL                                                                                         $1.00 

*Usage costs can be estimated by updating Infracost Cloud settings, see docs for other options.

──────────────────────────────────
20 cloud resources were detected:
∙ 2 were estimated
∙ 18 were free

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━┳━━━━━━━━━━━━┓
┃ Project                                            ┃ Baseline cost ┃ Usage cost* ┃ Total cost ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━╋━━━━━━━━━━━━┫
┃ main                                               ┃            $1 ┃           - ┃         $1 ┃
```
