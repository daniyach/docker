## Pasos para Desplegar Uptime Kuma con Docker Compose

> Nota: Esta información la he sacado de atareao con linux [github atareao](https://github.com/atareao), yo solo he adaptado a mis necesidades.
> En mi caso solamente lo he configurado con nginx-proxy de jwilder directamente en el propio docker-compose.yml, en caso de querer probar caddy o traefik, ir al repositorio de atareo.

### 1. Clonar el Repositorio

Primero, clona el repositorio desde GitHub que contiene los archivos necesarios:

```bash
git clone https://github.com/prueba/docker.git
```

### 2. Navegar al Directorio de Uptime Kuma

Cambia al directorio específico donde se encuentra la configuración de Uptime Kuma:

```bash
cd docker/uptime-kuma
```

### 3. Crear el Archivo de Entorno

Copia el archivo de entorno de muestra para crear tu propio archivo `.env`:

```bash
cp sample.env .env
```

### 4. Configurar el Archivo `.env`

Edita el archivo `.env` para configurar los valores específicos de tu entorno. Puedes usar `sed` para reemplazar los valores necesarios:

```bash
sed -i "s/uptime.tuservidor.es/<el_fqdn_que_quieras>/g" .env
```

```bash
sed -i "s/tu_correo@gmail.com/<tu_correo_electronico>/g" .env
```

### 5. Levantar el Docker Compose

Una vez configurado el archivo `.env`, levanta los contenedores definidos en el archivo `docker-compose.yml` en modo desacoplado (background):

```bash
docker compose up -d
```

### 6. Comprobar los Logs

Para asegurarte de que todo se ha levantado correctamente y verificar los logs, usa el siguiente comando:

```bash
docker compose logs -f
```

Este comando te permitirá ver los logs en tiempo real y verificar que los servicios se están ejecutando sin problemas.

### 7. (Opcional) Verificar el Estado de los Contenedores

Puedes verificar el estado de los contenedores usando:

```bash
docker ps
```

Esto te mostrará una lista de los contenedores que están corriendo, su estado y otros detalles relevantes.

### 8. (Opcional) Detener los Contenedores

Si necesitas detener los contenedores en algún momento, puedes hacerlo con:

```bash
docker compose down
```

Este comando detendrá y eliminará todos los contenedores definidos en el `docker-compose.yml`.

