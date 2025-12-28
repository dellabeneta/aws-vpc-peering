# Usage Guide: AWS Cross-Region Peering

This guide contains the necessary instructions to deploy the infrastructure for this project. The objective is to demonstrate a secure and private connection between two AWS regions.

---

## Prerequisites

Before starting, ensure you have the following installed:

1.  **[Terraform](https://developer.hashicorp.com/terraform/downloads)** (v1.0+)
2.  **[AWS CLI](https://aws.amazon.com/cli/)** configured with valid credentials.
3.  An active AWS account.

---

## Step 1: Configuration

To correctly execute Terraform, you must create a variable definition file.

1. In the project root, create a file named `terraform.tfvars`.
2. Enter the information as shown in the example below (adjust according to your environment):

```hcl
aws_profile          = "your-aws-profile" # e.g., "default"
project_name         = "my-peering-project"

aws_region_main      = "sa-east-1"
aws_region_secondary = "us-east-2"

vpc_sp_cidr           = "10.10.0.0/16"
subnet_sp_public_cidr = "10.10.1.0/24"
subnet_sp_public_2_cidr = "10.10.3.0/24"
subnet_sp_private_cidr = "10.10.2.0/24"

vpc_ohio_cidr        = "10.20.0.0/16"
subnet_ohio_private_cidr = "10.20.2.0/24"

ec2_instance_type    = "t3.micro"
```

---

## Step 2: Infrastructure Deployment

Run the following commands in your terminal:

1. **Initialize Terraform:**
   ```bash
   terraform init
   ```

2. **Validate the execution plan:**
   ```bash
   terraform plan
   ```

3. **Apply the changes:**
   ```bash
   terraform apply
   ```
   *(Confirm with `yes` when prompted to proceed)*.

---

## Step 3: Environment Verification

After the `apply` command completes, the terminal will display the outputs.

### Access via Internet
Use the address found in `sp_alb_dns_name` in your browser to verify the application's availability in São Paulo.

### Access to Instances (AWS Systems Manager)
For security reasons, the architecture does not use SSH keys or public access ports.
To access the servers:
1. Access the AWS Console.
2. Navigate to the **Systems Manager** service.
3. In the sidebar menu, select **Session Manager** and click **Start Session**.
4. Select the desired instance.

---

## Step 4: Resource Removal

To avoid unwanted costs after testing, remove all provisioned resources:

```bash
terraform destroy
```
*(Confirm with `yes` to process the deletion)*.

---

## Additional Remarks
- For estimated cost monitoring, consult the `cost-report.html` file (generated via Infracost).
- Communication between the São Paulo and Ohio instances is handled exclusively via the AWS private network through **VPC Peering**.

If you have any questions, consult the source code or open an issue in the repository.
