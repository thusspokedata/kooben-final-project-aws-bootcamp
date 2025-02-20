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

```sh
kilo@MacBookPro kooben-final-project-aws-bootcamp (main) % tfsec                                                                 

======================================================
tfsec is joining the Trivy family

tfsec will continue to remain available 
for the time being, although our engineering 
attention will be directed at Trivy going forward.

You can read more here: 
https://github.com/aquasecurity/tfsec/discussions/1994
======================================================

Result #1 HIGH Launch template does not require IMDS access to require a token 
────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  infra/modules/launch_template/main.tf:1-26
   via infra/main.tf:15-22 (module.backend_template)
────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    1  ┌ resource "aws_launch_template" "backend_template" {
    2  │   name = "backend-template-${var.sufix}"
    3  │ 
    4  │   image_id      = var.ec2_specs.ami
    5  │   instance_type = var.ec2_specs.instance_type
    6  │ 
    7  │   network_interfaces {
    8  │     associate_public_ip_address = true
    9  └     security_groups            = [var.backend_security_group_id]
   ..  
────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          ID aws-ec2-enforce-launch-config-http-token-imds
      Impact Instance metadata service can be interacted with freely
  Resolution Enable HTTP token requirement for IMDS

  More Information
  - https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/ec2/enforce-launch-config-http-token-imds/
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#metadata-options
────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


  timings
  ──────────────────────────────────────────
  disk i/o             3.633376ms
  parsing              11.230167ms
  adaptation           1.200666ms
  checks               2.0435ms
  total                18.107709ms

  counts
  ──────────────────────────────────────────
  modules downloaded   0
  modules processed    4
  blocks processed     59
  files read           16

  results
  ──────────────────────────────────────────
  passed               17
  ignored              0
  critical             0
  high                 1
  medium               0
  low                  0

  17 passed, 1 potential problem(s) detected.
```
