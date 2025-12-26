# Projeto DevOps - Terraform + Ansible + Django

Este repositório faz parte dos meus estudos de DevOps na formação da Alura. O projeto provisiona uma infraestrutura na AWS usando Terraform e configura um servidor Django automaticamente usando Ansible.

## 🛠 Tecnologias Utilizadas

- **Terraform**: Infraestrutura como Código (IaC) para criar a instância EC2 na AWS.
- **Ansible**: Gerenciamento de configuração para instalar pacotes e rodar o servidor Django.
- **AWS (EC2)**: Provedor de nuvem.
- **Python/Django**: Aplicação web provisionada.
- **WSL (Windows Subsystem for Linux)**: Ambiente necessário para rodar o Ansible no Windows.

## 📋 Pré-requisitos

Para rodar este projeto em ambiente Windows, você precisará:

1.  **WSL Instalado**: Ubuntu ou outra distro Linux (`wsl --install`).
2.  **AWS CLI Configurado**: Necessário para autenticação (`aws configure`).
3.  **Terraform**: Instalado no Windows ou no WSL.
3.  **Ansible**: Instalado **dentro do WSL** (não roda nativamente no Windows).
4.  **Chave SSH**: Arquivo `.pem` (ex: `iac-alura.pem`) para acesso à AWS.

## 🚀 Como Rodar o Projeto

### 1. Provisionar a Infraestrutura (Terraform)

Na pasta do projeto:

```bash
terraform init
terraform apply
```

Após confirmar, o Terraform irá criar a instância e devolver o **IP Público**.

### 2. Configurar o Inventário

Abra o arquivo `hosts.yml` e substitua o IP pelo novo IP gerado pelo Terraform:

```yaml
[terraform-ansible]
SEU_IP_NOVO_AQUI
```

### 3. Preparar o Ambiente Ansible (WSL)

Como estamos no Windows, precisamos de alguns ajustes para o Ansible funcionar via WSL.

**Atenção com a Chave PEM**: O sistema de arquivos do Windows não suporta as permissões estritas que o SSH exige (`600`).
Copie sua chave para o sistema de arquivos do Linux (dentro do WSL):

```bash
cp /mnt/c/Caminho/Para/Seu/Projeto/iac-alura.pem ~/.ssh/id_rsa_ansible.pem
chmod 600 ~/.ssh/id_rsa_ansible.pem
```

### 4. Executar o Playbook

Rode o comando abaixo dentro do terminal **WSL**.
*Nota: Usamos `ANSIBLE_HOST_KEY_CHECKING=False` para evitar falhas de verificação de host conhecida em ambientes dinâmicos.*

```bash
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook playbook.yml -u ubuntu --private-key ~/.ssh/id_rsa_ansible.pem -i hosts.yml
```

## 🔧 O que o Playbook Faz?

O `playbook.yml` executa as seguintes tarefas:
1.  Instala Python3, Pip e Virtualenv.
2.  Cria um ambiente virtual em `/home/ubuntu/tcc/venv`.
3.  Instala Django e Django Rest Framework.
4.  Inicia um projeto Django.
5.  Configura `ALLOWED_HOSTS = ['*']` para permitir acesso externo.
6.  **Roda o servidor Django em background** (usando `nohup`) para não travar o terminal.

## 🐛 Solução de Problemas Comuns

- **Erro `[WinError 1] Função incorreta`**: Você está tentando rodar Ansible pelo PowerShell/CMD. **Use o WSL**.
- **Erro `Unprotected private key file`**: Sua chave `.pem` está numa pasta do Windows (`/mnt/c/...`). Copie para a `~/.ssh/` do Linux e dê `chmod 600`.
- **Erro `Host key verification failed`**: O Ansible não reconhece o servidor novo. Use `ANSIBLE_HOST_KEY_CHECKING=False`.
