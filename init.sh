#!/bin/bash

# Iniciar los servicios con Docker Compose
docker-compose up -d

# Esperar un momento para asegurarse de que los servicios se hayan iniciado completamente
sleep 6

# Obtener la dirección IP del contenedor utilizando docker inspect
INSTANCE_ID=$(docker ps -qf "name=mysql-master")

# Obtener la dirección IP del contenedor utilizando docker inspect
IP_ADDRESS=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $INSTANCE_ID)

# Imprimir la dirección IP
echo "La IP es: $IP_ADDRESS"
sleep 5
# Configurar la replicación
docker exec mysql-master mysql -uroot -ptoor -e "CREATE USER IF NOT EXISTS 'replica'@'%' IDENTIFIED WITH 'mysql_native_password' BY '123'; GRANT REPLICATION SLAVE ON *.* TO 'replica'@'%'; FLUSH PRIVILEGES;"

# Obtener información del binlog del servidor maestro
MS_STATUS=$(docker exec mysql-master mysql -uroot -ptoor -e "SHOW MASTER STATUS")
CURRENT_LOG=$(echo $MS_STATUS | awk '{print $6}')
CURRENT_POS=$(echo $MS_STATUS | awk '{print $7}')

# Configurar el esclavo con la información del maestro
docker exec mysql-slave mysql -uroot -ptoor -e "CHANGE MASTER TO MASTER_HOST='$IP_ADDRESS', MASTER_USER='replica', MASTER_PASSWORD='123', MASTER_LOG_FILE='$CURRENT_LOG', MASTER_LOG_POS=$CURRENT_POS; START SLAVE;"

sleep 5

# Mostrar el estado del esclavo
docker exec mysql-slave mysql -uroot -ptoor -e "SHOW SLAVE STATUS \G"

# Crear una base de datos de prueba en el servidor maestro
docker exec mysql-master mysql -uroot -ptoor -e "CREATE DATABASE IF NOT EXISTS testdb;"


sleep 60