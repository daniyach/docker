#!/usr/bin/env bash
set -euo pipefail

# Total de pasos
TOTAL=13
STEP=0

# Función para mostrar un spinner mientras corre un comando
spinner() {
  local pid=$1
  local delay=0.1
  local spinstr='|/-\'
  while kill -0 "$pid" 2>/dev/null; do
    for c in $spinstr; do
      echo -ne "\r[$c] "
      sleep $delay
    done
  done
  echo -ne "\r[OK] "
}

# Función para ejecutar un paso con spinner
run_step() {
  (( STEP++ ))
  local desc=$1; shift
  echo -n "Paso $STEP/$TOTAL: $desc... "
  # ejecuta el comando en background
  "$@" >/dev/null 2>&1 &
  local pid=$!
  spinner "$pid"
  wait "$pid"
  echo
}

# 1. Verificar ejecución como root
if [[ "$EUID" -ne 0 ]]; then
  echo "¡Este script debe correr como root! Usa sudo."
  exit 1
fi

# 2. Verificar OS
. /etc/os-release
if [[ "$ID" != "ubuntu" || "$VERSION_ID" != "22.04" ]]; then
  echo "Sólo Ubuntu 22.04 LTS es soportado."
  exit 1
fi

# 3. Verificar arquitectura
ARCH=$(dpkg --print-architecture)
if [[ "$ARCH" != "amd64" && "$ARCH" != "arm64" ]]; then
  echo "Arquitectura no soportada: $ARCH"
  exit 1
fi

# 4. Desinstalar paquetes conflictivos
run_step "Eliminando paquetes conflictivos" bash -c \
  'for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do apt-get remove -y "$pkg" || true; done'

# 5. Actualizar índices de APT
run_step "Actualizando índices de paquetes" apt-get update

# 6. Instalar prerequisitos
run_step "Instalando ca-certificates, curl, gnupg, lsb-release" \
  apt-get install -y ca-certificates curl gnupg lsb-release

# 7. Crear directorio de keyrings
run_step "Creando /etc/apt/keyrings" install -m 0755 -d /etc/apt/keyrings

# 8. Descargar y registrar clave GPG
run_step "Descargando clave GPG de Docker" \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

run_step "Ajustando permisos de la clave" chmod a+r /etc/apt/keyrings/docker.asc

# 9. Añadir repositorio de Docker
run_step "Agregando repositorio de Docker" bash -c \
  'echo "deb [arch='"$ARCH"' signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu '"${UBUNTU_CODENAME:-$VERSION_CODENAME}"' stable" \
   | tee /etc/apt/sources.list.d/docker.list > /dev/null'

# 10. Actualizar índices tras añadir repo
run_step "Actualizando índices tras añadir repositorio" apt-get update

# 11. Instalar Docker Engine y plugins
run_step "Instalando docker-ce, cli, containerd, buildx y compose" \
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 12. Habilitar e iniciar servicio Docker
run_step "Habilitando e iniciando servicio Docker" bash -c \
  'systemctl enable docker && systemctl start docker'

# 13. Añadir usuario al grupo docker
TARGET_USER="${SUDO_USER:-$USER}"
run_step "Añadiendo usuario '$TARGET_USER' al grupo docker" \
  usermod -aG docker "$TARGET_USER"

# Mensajes finales (no cuentan como paso)
echo
echo "✅ Instalación completada. Cierra sesión y vuelve a entrar para aplicar el grupo 'docker'."
echo "⚠️ Recuerda definir tus reglas de firewall en la cadena DOCKER-USER si usas ufw o nftables."
echo
docker --version && docker compose version || echo "docker o docker compose no se encuentran disponibles aún."
echo "Prueba: sudo docker run hello-world"
