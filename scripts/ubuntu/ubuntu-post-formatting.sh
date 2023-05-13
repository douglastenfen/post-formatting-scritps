#!/usr/bin/env bash
set -e

# Verifica se o usuário está executando o script como superusuário
if [ $(id -u) -ne 0 ]; then
  echo "Este script precisa ser executado como superusuário (root)"
  exit 1
fi

# Verifica se o sistema está conectado à internet
if ! ping -c 1 google.com &> /dev/null; then
  echo "Não foi possível conectar à internet"
  exit 1
fi

# Lista de pacotes para instalar via apt
pacotes_apt=(git curl zsh dconf-cli fonts-firacode) 

# Lista de pacotes para instalar via snap
snaps=(spotify insomnia)
snaps_classic=(code)

# Atualiza a lista de pacotes
apt update

# Confirmação antes da instalação dos pacotes
echo "Os seguintes pacotes serão instalados:"
echo "Pacotes apt: ${pacotes_apt[@]}"
echo "Snaps: ${snaps[@]}"
echo "Snaps classic: ${snaps_classic[@]}"
read -p "Deseja continuar? (S/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
  exit 0
fi
# Instala os pacotes via apt
apt install -y ${pacotes_apt[@]}

# Instala os pacotes via snap
snap install ${snaps[@]}
snap install --classic ${snaps_classic[@]}


if [ -x "$(command -v zsh)" ]; then
  # Define zsh como shell padrão
  echo "Definindo ZSH como Shell padrão"
  chsh -s $(which zsh)
fi
