# AWS Cross-Region Architecture with VPC Peering and High Availability

[Versão em Português](./README.md)

**Note:** See the [Usage Guide (How-to-Use)](./how-to-use-en.md) for step-by-step instructions on deploying this project.

**Overview**
Distributed architecture across **sa-east-1 (São Paulo)** and **us-east-2 (Ohio)** regions designed for total isolation. External traffic is admitted via an Application Load Balancer (ALB) in High Availability, while internal communication and management utilize VPC Peering and **VPC Endpoints** to ensure maximum security without exposure to the public internet.

## 1. Network Structure

**Region A: sa-east-1 (São Paulo)**
* VPC CIDR: `10.10.0.0/16`
* Gateway: Internet Gateway (IGW) for public traffic.
* Subnets:
    * Public Subnet A (`10.10.1.0/24`): ALB Zone A.
    * Public Subnet B (`10.10.3.0/24`): ALB Zone B (High Availability).
    * Private Subnet (`10.10.2.0/24`): Hosts the EC2 (Application).

**Region B: us-east-2 (Ohio)**
* VPC CIDR: `10.20.0.0/16`
* Subnets:
    * Private Subnet (`10.20.2.0/24`): Hosts the EC2 (MySQL Database).

## 2. Routing (Route Tables)

**RT-Public (sa-east-1)**
*Associated with Subnets `10.10.1.0/24` and `10.10.3.0/24`*
* 10.10.0.0/16: Local
* 0.0.0.0/0: Internet Gateway (igw-id)

**RT-Private-App (sa-east-1)**
*Associated with Subnet `10.10.2.0/24`*
* 10.10.0.0/16: Local
* 10.20.0.0/16: Peering Connection (pcx-id)

**RT-Private-DB (us-east-2)**
*Associated with Subnet `10.20.2.0/24`*
* 10.20.0.0/16: Local
* 10.10.0.0/16: Peering Connection (pcx-id)

## 3. Security Groups (Firewall)

**SG-ALB (Load Balancer)**
* Inbound: Ports 80/443 (HTTP/HTTPS) via `0.0.0.0/0`.
* Outbound: Port 80 (HTTP) to the Application Security Group.

**SG-App (Application EC2)**
* Inbound: Port 80 (HTTP) allowed only from `SG-ALB` source.
* Outbound: Port 3306 (MySQL) to CIDR `10.20.2.0/24`.

**SG-DB (Database EC2)**
* Inbound: Port 3306 (MySQL) allowed only from CIDR `10.10.2.0/24` source.
* Outbound: Restricted.

## 4. Management and Private Access

To ensure **total internet isolation**, instances in private subnets do not have a NAT Gateway or Internet Gateway. Management is performed via **AWS PrivateLink (VPC Endpoints)**:

* SSM Endpoints (Interface): Allow access via AWS Systems Manager (Session Manager) using the AWS internal network for remote management without public exposure.
* S3 Endpoint (Gateway): Allows instances to consume files and installers from S3 buckets directly, without traffic over the public internet.
