# Guia de Uso: AWS Cross-Region Peering

Este guia contém as instruções necessárias para implantar a infraestrutura deste projeto. O objetivo é demonstrar a conexão entre duas regiões da AWS de forma segura e privada.

---

## Pré-requisitos

Antes de iniciar, certifique-se de ter instalado:

1.  **[Terraform](https://developer.hashicorp.com/terraform/downloads)** (v1.0+)
2.  **[AWS CLI](https://aws.amazon.com/cli/)** configurado com credenciais válidas.
3.  Uma conta AWS ativa.

---

## Passo 1: Configuração

Para a correta execução do Terraform, é necessário criar um arquivo de definição de variáveis.

1. Na raiz do projeto, crie um arquivo chamado `terraform.tfvars`.
2. Insira as informações conforme o exemplo abaixo (ajuste de acordo com seu ambiente):

```hcl
aws_profile          = "seu-profile-aws" # Ex: "default"
project_name         = "meu-peering-projeto"

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

## Passo 2: Implantação da Infraestrutura

Execute os comandos a seguir no seu terminal:

1. **Inicializar o Terraform:**
   ```bash
   terraform init
   ```

2. **Validar o plano de execução:**
   ```bash
   terraform plan
   ```

3. **Aplicar as alterações:**
   ```bash
   terraform apply
   ```
   *(Confirme com `yes` quando solicitado para prosseguir)*.

---

## Passo 3: Verificação do Ambiente

Após a conclusão do comando `apply`, o terminal exibirá as informações de saída (outputs).

### Acesso via Internet
Utilize o endereço presente em `sp_alb_dns_name` no seu navegador para verificar a disponibilidade da aplicação em São Paulo.

### Acesso às Instâncias (AWS Systems Manager)
Por motivos de segurança, a arquitetura não utiliza chaves SSH ou portas de acesso público.
Para acessar os servidores:
1. Acesse o Console da AWS.
2. Navegue até o serviço **Systems Manager**.
3. No menu lateral, selecione **Session Manager** e clique em **Start Session**.
4. Selecione a instância desejada.

---

## Passo 4: Remoção dos Recursos

Para evitar custos indesejados após os testes, remova todos os recursos provisionados:

```bash
terraform destroy
```
*(Confirme com `yes` para processar a exclusão)*.

---

## Observações Adicionais
- Para monitoramento de custos estimados, consulte o arquivo `cost-report.html` (gerado via Infracost).
- A comunicação entre as instâncias de São Paulo e Ohio é feita exclusivamente via rede privada AWS através do **VPC Peering**.

Em caso de dúvidas, consulte o código-fonte ou abra uma issue no repositório.
