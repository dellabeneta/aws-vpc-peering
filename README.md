# Arquitetura AWS Cross-Region com VPC Peering e Alta Disponibilidade

[English version](./README-en.md)

**Nota:** Consulte o [Guia de Uso (How-to-Use)](./how-2-use.md) para instruções passo a passo sobre a implantação deste projeto.

**Visão Geral**

Arquitetura distribuída entre as regiões **sa-east-1 (São Paulo)** e **us-east-2 (Ohio)** projetada para isolamento total. O tráfego externo é admitido via Application Load Balancer (ALB) em Alta Disponibilidade, enquanto a comunicação interna e o gerenciamento utilizam VPC Peering e **VPC Endpoints** para garantir máxima segurança sem exposição à internet pública.

## 1. Estrutura de Rede

**Região A: sa-east-1 (São Paulo)**
* VPC CIDR: `10.10.0.0/16`
* Gateway: Internet Gateway (IGW) para tráfego público.
* Subnets:
    * Public Subnet A (`10.10.1.0/24`): ALB Zona A.
    * Public Subnet B (`10.10.3.0/24`): ALB Zona B (Alta Disponibilidade).
    * Private Subnet (`10.10.2.0/24`): Hospeda a EC2 (Aplicação).

**Região B: us-east-2 (Ohio)**
* VPC CIDR: `10.20.0.0/16`
* Subnets:
    * Private Subnet (`10.20.2.0/24`): Hospeda a EC2 (MySQL Database).

## 2. Roteamento (Route Tables)

**RT-Public (sa-east-1)**
*Associada às Subnets `10.10.1.0/24` e `10.10.3.0/24`*
* 10.10.0.0/16: Local
* 0.0.0.0/0: Internet Gateway (igw-id)

**RT-Private-App (sa-east-1)**
*Associada à Subnet `10.10.2.0/24`*
* 10.10.0.0/16: Local
* 10.20.0.0/16: Peering Connection (pcx-id)

**RT-Private-DB (us-east-2)**
*Associada à Subnet `10.20.2.0/24`*
* 10.20.0.0/16: Local
* 10.10.0.0/16: Peering Connection (pcx-id)

## 3. Security Groups (Firewall)

**SG-ALB (Load Balancer)**
* Inbound: Portas 80/443 (HTTP/HTTPS) via `0.0.0.0/0`.
* Outbound: Porta 80 (HTTP) para o Security Group da Aplicação.

**SG-App (EC2 Aplicação)**
* Inbound: Porta 80 (HTTP) permitido apenas origem `SG-ALB`.
* Outbound: Porta 3306 (MySQL) para o CIDR `10.20.2.0/24`.

**SG-DB (EC2 Banco de Dados)**
* Inbound: Porta 3306 (MySQL) permitido apenas origem CIDR `10.10.2.0/24`.
* Outbound: Restrito.

## 4. Gerenciamento e Acesso Privado

Para garantir **isolamento total da internet**, as instâncias nas sub-redes privadas não possuem NAT Gateway nem Internet Gateway. O gerenciamento é feito via **AWS PrivateLink (VPC Endpoints)**:

* SSM Endpoints (Interface): Permitem o acesso via AWS Systems Manager (Session Manager) utilizando a rede interna da AWS para gerenciamento remoto sem exposição pública.
* S3 Endpoint (Gateway): Permite que as instâncias consumam arquivos e instaladores de buckets S3 diretamente, sem tráfego pela internet pública.