# **Using tfsec for Terraform Security Scanning**

## **Why Use tfsec?**
tfsec is a static analysis security scanner for Terraform configurations. It helps identify security vulnerabilities and misconfigurations before deploying infrastructure, ensuring compliance with best practices and security standards.

## **Benefits of Using tfsec**
- **Security Best Practices:** Detects security issues in Terraform code before deployment.
- **Fast and Lightweight:** Runs quickly without requiring complex setup.
- **Continuous Integration:** Can be integrated into CI/CD pipelines for automated security checks.
- **Detailed Reporting:** Provides insights into detected vulnerabilities with severity levels.
- **Prevention Over Remediation:** Helps address security risks early in the development cycle.

## **Example: Running tfsec in a Terraform Project**
The following example demonstrates running `tfsec` on a Terraform project:


## **Real Case Example: EC2-RDS Scheduler Module**
When implementing the EC2-RDS scheduler module from a public repository, tfsec identified several security concerns. Here's the actual output:

### Resolution
After seeing these warnings, I created a fork of the module to implement security improvements:
- Restricted IAM policies to specific resources
- Enabled Lambda tracing
- Improved security practices while maintaining functionality

This demonstrates how tfsec helps identify and address security vulnerabilities in third-party modules. 

```sh
Result #1 HIGH IAM policy document uses sensitive action 'logs:CreateLogGroup' on wildcarded resource 'arn:aws:logs:*:*:*' 
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  git::https:/github.com/eanselmi/terraform-aws-ec2-rds-scheduler?ref=f60d429ba12b9db8c9e022d32553eb4f99d7e616/iam.tf:36
   via infra/main.tf:75-83 (module.ec2-rds-scheduler)
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   21    resource "aws_iam_role_policy" "lambda_policy" {
   ..  
   36  [             "Resource": "arn:aws:logs:*:*:*"
   ..  
   61    }
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-iam-no-policy-wildcards
      Impact Overly permissive policies may grant access to sensitive resources
  Resolution Specify the exact permissions required, and to which resources they should apply instead of using wildcards.

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/iam/no-policy-wildcards/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #2 HIGH IAM policy document uses sensitive action 'ec2:StopInstances' on wildcarded resource '*' 
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  git::https:/github.com/eanselmi/terraform-aws-ec2-rds-scheduler?ref=f60d429ba12b9db8c9e022d32553eb4f99d7e616/iam.tf:56
   via infra/main.tf:75-83 (module.ec2-rds-scheduler)
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   21    resource "aws_iam_role_policy" "lambda_policy" {
   ..  
   56  [             "Resource": "*"
   ..  
   61    }
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-iam-no-policy-wildcards
      Impact Overly permissive policies may grant access to sensitive resources
  Resolution Specify the exact permissions required, and to which resources they should apply instead of using wildcards.

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/iam/no-policy-wildcards/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #3 HIGH IAM policy document uses sensitive action 'lambda:InvokeFunction' on wildcarded resource '*' 
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  git::https:/github.com/eanselmi/terraform-aws-ec2-rds-scheduler?ref=f60d429ba12b9db8c9e022d32553eb4f99d7e616/iam.tf:67
   via infra/main.tf:75-83 (module.ec2-rds-scheduler)
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   63    resource "aws_iam_policy" "cloudwatch_events_policy" {
   ..  
   67  [     Version = "2012-10-17",
   ..  
   78    }
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-iam-no-policy-wildcards
      Impact Overly permissive policies may grant access to sensitive resources
  Resolution Specify the exact permissions required, and to which resources they should apply instead of using wildcards.

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/iam/no-policy-wildcards/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #4 LOW Function does not have tracing enabled. 
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  git::https:/github.com/eanselmi/terraform-aws-ec2-rds-scheduler?ref=f60d429ba12b9db8c9e022d32553eb4f99d7e616/lambda.tf:12-19
   via infra/main.tf:75-83 (module.ec2-rds-scheduler)
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   12    resource "aws_lambda_function" "ec2_start" {
   13      filename      = "${path.module}/resources/ec2_start.zip"
   14      function_name = "ec2_start"
   15      role          = aws_iam_role.lambda_role.arn
   16      handler       = "ec2_start.lambda_handler"
   17      runtime       = "python3.8"
   18      timeout       = 30
   19    }
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-lambda-enable-tracing
      Impact Without full tracing enabled it is difficult to trace the flow of logs
  Resolution Enable tracing

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/lambda/enable-tracing/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#mode
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #5 LOW Function does not have tracing enabled. 
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  git::https:/github.com/eanselmi/terraform-aws-ec2-rds-scheduler?ref=f60d429ba12b9db8c9e022d32553eb4f99d7e616/lambda.tf:22-29
   via infra/main.tf:75-83 (module.ec2-rds-scheduler)
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   22    resource "aws_lambda_function" "rds_shutdown" {
   23      filename      = "${path.module}/resources/rds_shutdown.zip"
   24      function_name = "rds_shutdown"
   25      role          = aws_iam_role.lambda_role.arn
   26      handler       = "rds_shutdown.lambda_handler"
   27      runtime       = "python3.8"
   28      timeout       = 30
   29    }
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-lambda-enable-tracing
      Impact Without full tracing enabled it is difficult to trace the flow of logs
  Resolution Enable tracing

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/lambda/enable-tracing/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#mode
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #6 LOW Function does not have tracing enabled. 
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  git::https:/github.com/eanselmi/terraform-aws-ec2-rds-scheduler?ref=f60d429ba12b9db8c9e022d32553eb4f99d7e616/lambda.tf:3-10
   via infra/main.tf:75-83 (module.ec2-rds-scheduler)
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    3    resource "aws_lambda_function" "ec2_shutdown" {
    4      filename      = "${path.module}/resources/ec2_shutdown.zip"
    5      function_name = "ec2_shutdown"
    6      role          = aws_iam_role.lambda_role.arn
    7      handler       = "ec2_shutdown.lambda_handler"
    8      runtime       = "python3.8"
    9      timeout       = 30
   10    }
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-lambda-enable-tracing
      Impact Without full tracing enabled it is difficult to trace the flow of logs
  Resolution Enable tracing

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/lambda/enable-tracing/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#mode
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #7 LOW Function does not have tracing enabled. 
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  git::https:/github.com/eanselmi/terraform-aws-ec2-rds-scheduler?ref=f60d429ba12b9db8c9e022d32553eb4f99d7e616/lambda.tf:31-38
   via infra/main.tf:75-83 (module.ec2-rds-scheduler)
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   31    resource "aws_lambda_function" "rds_start" {
   32      filename      = "${path.module}/resources/rds_start.zip"
   33      function_name = "rds_start"
   34      role          = aws_iam_role.lambda_role.arn
   35      handler       = "rds_start.lambda_handler"
   36      runtime       = "python3.8"
   37      timeout       = 30
   38    }
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-lambda-enable-tracing
      Impact Without full tracing enabled it is difficult to trace the flow of logs
  Resolution Enable tracing

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/lambda/enable-tracing/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#mode
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #8 LOW Function does not have tracing enabled. 
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  git::https:/github.com/eanselmi/terraform-aws-ec2-rds-scheduler?ref=f60d429ba12b9db8c9e022d32553eb4f99d7e616/lambda.tf:40-47
   via infra/main.tf:75-83 (module.ec2-rds-scheduler)
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   40    resource "aws_lambda_function" "asg_shutdown" {
   41      filename      = "${path.module}/resources/asg_shutdown.zip"
   42      function_name = "asg_shutdown"
   43      role          = aws_iam_role.lambda_role.arn
   44      handler       = "asg_shutdown.lambda_handler"
   45      runtime       = "python3.8"
   46      timeout       = 30
   47    }
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-lambda-enable-tracing
      Impact Without full tracing enabled it is difficult to trace the flow of logs
  Resolution Enable tracing

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/lambda/enable-tracing/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#mode
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #9 LOW Function does not have tracing enabled. 
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  git::https:/github.com/eanselmi/terraform-aws-ec2-rds-scheduler?ref=f60d429ba12b9db8c9e022d32553eb4f99d7e616/lambda.tf:49-56
   via infra/main.tf:75-83 (module.ec2-rds-scheduler)
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   49    resource "aws_lambda_function" "asg_start" {
   50      filename      = "${path.module}/resources/asg_start.zip"
   51      function_name = "asg_start"
   52      role          = aws_iam_role.lambda_role.arn
   53      handler       = "asg_start.lambda_handler"
   54      runtime       = "python3.8"
   55      timeout       = 30
   56    }
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-lambda-enable-tracing
      Impact Without full tracing enabled it is difficult to trace the flow of logs
  Resolution Enable tracing

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/lambda/enable-tracing/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#mode
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #10 LOW Function does not have tracing enabled. 
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  git::https:/github.com/eanselmi/terraform-aws-ec2-rds-scheduler?ref=f60d429ba12b9db8c9e022d32553eb4f99d7e616/lambda.tf:58-65
   via infra/main.tf:75-83 (module.ec2-rds-scheduler)
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   58    resource "aws_lambda_function" "aurora_shutdown" {
   59      filename      = "${path.module}/resources/aurora_shutdown.zip"
   60      function_name = "aurora_shutdown"
   61      role          = aws_iam_role.lambda_role.arn
   62      handler       = "aurora_shutdown.lambda_handler"
   63      runtime       = "python3.8"
   64      timeout       = 30
   65    }
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-lambda-enable-tracing
      Impact Without full tracing enabled it is difficult to trace the flow of logs
  Resolution Enable tracing

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/lambda/enable-tracing/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#mode
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


Result #11 LOW Function does not have tracing enabled. 
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  git::https:/github.com/eanselmi/terraform-aws-ec2-rds-scheduler?ref=f60d429ba12b9db8c9e022d32553eb4f99d7e616/lambda.tf:67-74
   via infra/main.tf:75-83 (module.ec2-rds-scheduler)
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   67    resource "aws_lambda_function" "aurora_start" {
   68      filename      = "${path.module}/resources/aurora_start.zip"
   69      function_name = "aurora_start"
   70      role          = aws_iam_role.lambda_role.arn
   71      handler       = "aurora_start.lambda_handler"
   72      runtime       = "python3.8"
   73      timeout       = 30
   74    }
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-lambda-enable-tracing
      Impact Without full tracing enabled it is difficult to trace the flow of logs
  Resolution Enable tracing

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/lambda/enable-tracing/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#mode
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


  timings
  ──────────────────────────────────────────
  disk i/o             3.400665ms
  parsing              1.008631957s
  adaptation           2.333833ms
  checks               14.814833ms
  total                1.029181288s

  counts
  ──────────────────────────────────────────
  modules downloaded   1
  modules processed    9
  blocks processed     160
  files read           29

  results
  ──────────────────────────────────────────
  passed               58
  ignored              0
  critical             0
  high                 3
  medium               0
  low                  8

  58 passed, 11 potential problem(s) detected.
```
