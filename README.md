# Docker

## Introducción
Este repositorio tiene como objetivo principal guardar todos los Docker que voy probando junto con su configuración e instalación. Aquí encontrarás diferentes directorios, cada uno con su propio conjunto de archivos de configuración y scripts necesarios para desplegar diversas aplicaciones y servicios utilizando Docker.

## Tabla de Contenidos

| Directorio     | Descripción                                                      |
|----------------|------------------------------------------------------------------|
| [uptime-kuma](https://github.com/daniyach/docker/tree/main/uptime-kuma)  | Configuración e instalación de Uptime Kuma utilizando Docker.    |
| ...            | ...                                                              |

---

## Instalación de Docker con script

### Descripción
Este script instala Docker en una máquina con Ubuntu. Verifica si Docker está instalado y, si no lo está, procede a instalarlo.


#### 1. Clona este repositorio o descarga el script directamente.

```bash
git clone https://github.com/daniyach/docker.git
```
    
```bash
cd docker
```

#### 2. Asegúrate de que el script tenga permisos de ejecución.

```sh
chmod +x install_docker.sh
```

#### 3. Ejecuta el script con privilegios de `sudo`.

```sh
sudo ./install_docker.sh
```

> Después de la instalación, cierra sesión y vuelve a iniciarla para aplicar los cambios de grupo.

---

## Instalación de Docker manualmente

### Paso 1: Actualizar los Repositorios y Paquetes

Actualiza la lista de paquetes disponibles e instala las dependencias necesarias:

```bash
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
```

### Paso 2: Añadir la Clave GPG de Docker

Crea un directorio para las claves y añade la clave GPG de Docker:

```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

### Paso 3: Configurar el Repositorio de Docker

Añade el repositorio de Docker a la lista de fuentes de APT:

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

> **Nota:** Si estás utilizando un sistema operativo diferente a Ubuntu, cambia la URL del repositorio a la correspondiente. Por ejemplo, para Debian usa `https://download.docker.com/linux/debian`.

### Paso 4: Instalar Docker

Actualiza la lista de paquetes e instala Docker:

```bash
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### Paso 5: Añadir el Usuario al Grupo Docker

Añade tu usuario al grupo `docker` para poder ejecutar comandos de Docker sin `sudo`:

```bash
sudo usermod -aG docker $USER
```

> **Nota:** Después de ejecutar este comando, cierra la sesión y vuelve a iniciarla para que los cambios tengan efecto.
