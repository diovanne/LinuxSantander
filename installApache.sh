#!/bin/bash

# Verifica se o script está sendo executado como root
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, execute como root"
  exit 1
fi

echo "Atualizando repositórios..."
apt update -y

echo "Instalando Apache..."
apt install apache2 -y

echo "Habilitando e iniciando o serviço Apache..."
systemctl enable apache2
systemctl start apache2

echo "Configurando o Firewall para permitir o tráfego HTTP e HTTPS..."
ufw allow 'Apache'
ufw reload

echo "Criando página padrão personalizada..."
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
  <title>Servidor Apache</title>
</head>
<body>
  <h1>Apache instalado com sucesso!</h1>
  <p>Servidor web funcionando no $(hostname -f)</p>
</body>
</html>
EOF

echo "Verificando status do Apache..."
systemctl status apache2 | grep Active

echo "Instalação e configuração concluídas com sucesso!"

