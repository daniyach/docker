#Installation

nota: Esta información la he sacado de atareao con linux [github atareao](https://github.com/atareao), yo solo he adaptado a mis necesidades.

```
git clone https://github.com/daniyach/docker.git
cd docker/uptime-kuma
cp sample.env .env
sed -i "s/uptime.tuservidor.es/<el_fqdn_que_quieras>/g" .env
mkdir data
```

A la hora de levantar el servicio dependerá del proxy inverso que hayas seleccionado. Si has elegido Caddy, simplemente,
En mi caso solamente lo he configurado con Traefik, en caso de querer probar caddy, ir al repositorio de atareo.

```
docker-compose -f docker-compose.yml -f docker-compose.traefik.yml up -d
docker-compose logs -f
```

