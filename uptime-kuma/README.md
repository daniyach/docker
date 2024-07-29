#Installation

nota: Esta información la he sacado de atareao con linux [github atareao](https://github.com/atareao), yo solo he adaptado a mis necesidades.

```
git clone https://github.com/daniyach/docker.git
cd docker/uptime-kuma
cp sample.env .env
sed -i "s/uptime.tuservidor.es/<el_fqdn_que_quieras>/g" .env
sed -i "s/tu_correo@gmail.com/<tu_correo_electronico>/g" .env
```

```
docker compose up -d
docker compose logs -f
```

En mi caso solamente lo he configurado con nginx-proxy de jwilder directamente en el propio docker-compose.yml, en caso de querer probar caddy o traefik, ir al repositorio de atareo.
