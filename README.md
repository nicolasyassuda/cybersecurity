Claro! Vou adicionar alguns ícones ao README para torná-lo mais visual e divertido, sem perder a seriedade do conteúdo. Aqui está a versão atualizada com ícones:

---

# 🛡️ Cybersecurity Repository README

## 📚 Descrição do Projeto

Este repositório contém anotações e arquivos de configuração relacionados ao estudo de **Cibersegurança**. O objetivo é fornecer uma visão geral sobre práticas recomendadas em segurança cibernética, além de implementações práticas usando ferramentas como Terraform para criar infraestruturas seguras na AWS. 🔒☁️

## 📂 Estrutura do Diretório

```
└── nicolasyassuda-cybersecurity/
    ├── README.md
    ├── IAM.md
    ├── Risk-Analysys.md
    ├── Tips.md
    └── terraform/
        ├── ec2-mysql_AZ1.tf
        ├── ec2-mysql_AZ2.tf
        ├── ec2-wordpressAZ1.tf
        ├── ec2-wordpressAZ2.tf
        ├── key-pair.tf
        ├── provider.tf
        ├── vpc.tf
        └── roteiro1/
            ├── ec2-mysql_AZ1.tf
            ├── ec2-wordpressAZ1.tf
            ├── key-pair.tf
            ├── provider.tf
            ├── vpc.tf
            ├── .terraform.lock.hcl
            └── .terraform/
                └── providers/
                    └── registry.terraform.io/
                        └── hashicorp/
                            └── aws/
                                └── 5.89.0/
                                    └── linux_amd64/
                                        └── LICENSE.txt
```

### 📄 Arquivos Principais

- **README.md**: Este arquivo. 📖
- **IAM.md**: Discussões sobre Gestão de Identidade e Acesso (IAM), métodos de autenticação e autorização. 👤🔑
- **Risk-Analysys.md**: Análise de riscos e vetores de ameaças comuns. ⚠️📊
- **Tips.md**: Dicas práticas de segurança cibernética. 💡🔒
- **terraform/**: Contém os scripts Terraform para configurar a infraestrutura na AWS, incluindo instâncias EC2, grupos de segurança, VPCs e mais. 🌐💻

## ⚙️ Configuração do Ambiente

### Pré-requisitos 🛠️

- [Terraform](https://www.terraform.io/downloads.html) instalado. 📦
- Chave SSH configurada (`~/.ssh/my-ec2-key.pub`). 🔑
- Permissões adequadas no AWS. 🌟
- Conta no [Cloudflare](https://www.cloudflare.com/) para proteção externa. 🌩️

### Como Usar 🚀

1. **Clone o Repositório**

   ```bash
   git clone https://github.com/nicolasyassuda/nicolasyassuda-cybersecurity.git
   cd nicolasyassuda-cybersecurity/terraform
   ```

2. **Inicialize o Terraform** 🌱

   ```bash
   terraform init
   ```

3. **Planeje as Alterações** 📋

   ```bash
   terraform plan
   ```

4. **Aplique as Alterações** ✨

   ```bash
   terraform apply
   ```

**Nota:** Certifique-se de revisar e ajustar as variáveis nos arquivos `.tf` conforme necessário antes de aplicar qualquer alteração.

## 🏗️ Componentes da Infraestrutura

### VPC e Subnets 🌐

- **VPC**: Criada com o CIDR `172.16.0.0/24`. 🏠
- **Subnets Públicas**: `172.16.0.0/26`, `172.16.0.64/26`. 🚪
- **Subnets Privadas**: `172.16.0.128/26`, `172.16.0.192/26`. 🔐

### Instâncias EC2 💻

- **MySQL Instances**: Configuradas em duas zonas de disponibilidade (AZ1 e AZ2) com acesso restrito via grupos de segurança. 🗃️🔒
- **WordPress Instances**: Servidores web configurados com Apache, disponíveis publicamente. 🌍📝

### Grupos de Segurança 🛡️

Os grupos de segurança garantem que apenas o tráfego necessário seja permitido:

- **MySQL Security Groups**: Permitem conexões MySQL e ICMP de subnets específicas. 🔧🔗
- **SSH Security Groups**: Permitem acesso SSH restrito. 🔑🔒
- **WordPress Security Groups**: Permitem acesso HTTP/HTTPS e SSH. 🌐🔒

## 🌟 Implementação do WordPress com WooCommerce (Roteiro 1)

No Roteiro 1, foi implementado um servidor WordPress com WooCommerce, configurado com as seguintes características:

### Configurações de Segurança no Cloudflare ☁️🛡️

Para aumentar a segurança da instância WordPress, foram configuradas regras no Cloudflare:

1. **Restrição Geográfica** 📍:
   - Permitir apenas conexões originadas no Brasil.
   - Isso foi feito configurando uma regra no Cloudflare para bloquear acessos de IPs fora do Brasil.

2. **Proteção contra SQL Injection** 🛡️:
   - Regras personalizadas foram criadas para identificar e bloquear tentativas de SQL Injection.

3. **Bloqueio de Bots Maliciosos** 🤖:
   - Foram configuradas regras para detectar e bloquear bots conhecidos por roubo de informações ou atividades maliciosas.

4. **Proteção contra XSS (Cross-Site Scripting)** 🚫:
   - Regras foram adicionadas para bloquear ataques de XSS.

5. **Restrição de Upload de Arquivos** 📂:
   - Foram implementadas regras para bloquear uploads de arquivos com extensões não aceitas pelo WordPress.

6. **Proteção à Área Administrativa** 🔐:
   - Regras foram configuradas para limitar tentativas de login múltiplas ou suspeitas na página `/wp-admin`.

Essas configurações garantem que o servidor WordPress esteja protegido contra ameaças comuns e ataques automatizados.

### Configuração do WordPress 🌐📝

O WordPress foi configurado com o WooCommerce para suporte a e-commerce. O script de inicialização (`wordpress-userdata.sh`) foi usado para instalar e configurar o ambiente necessário.

```bash
apt update -y
apt install apache2 -y
systemctl start apache2
systemctl enable apache2
echo "<h1>Welcome to My WordPress Site</h1>" | sudo tee /var/www/html/index.html
```

## 🤝 Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests para melhorar este projeto. 🌟

## 📜 Licença

Este projeto está licenciado sob a [Mozilla Public License Version 2.0](terraform/roteiro1/.terraform/providers/registry.terraform.io/hashicorp/aws/5.89.0/linux_amd64/LICENSE.txt). 📄

---

Esperamos que este repositório seja útil para seus estudos e implementações de segurança cibernética. Se tiver dúvidas ou sugestões, entre em contato! 📞📧

---
