INSTANCE_ID=$(docker ps -qf "name=mysql-master")

# Obtener la dirección IP del contenedor utilizando docker inspect
IP_ADDRESS=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $INSTANCE_ID)

# Obtener información del binlog del servidor maestro
MS_STATUS=$(docker exec mysql-master mysql -uroot -ptoor -e "SHOW MASTER STATUS")
CURRENT_LOG=$(echo $MS_STATUS | awk '{print $6}')
CURRENT_POS=$(echo $MS_STATUS | awk '{print $7}')

#mostrar ms status
echo "MS_STATUS: $MS_STATUS"
echo "CURRENT_LOG: $CURRENT_LOG"
echo "CURRENT_POS: $CURRENT_POS"
echo "IP_ADDRESS: $IP_ADDRESS"
echo "---------------------------"
echo "CHANGE MASTER TO MASTER_HOST='$IP_ADDRESS', MASTER_USER='replica', MASTER_PASSWORD='123', MASTER_LOG_FILE='$CURRENT_LOG', MASTER_LOG_POS=$CURRENT_POS"
echo "---------------------------"
echo "CREATE USER IF NOT EXISTS 'replica'@'$IP_ADDRESS' IDENTIFIED WITH 'mysql_native_password' BY '123'; GRANT REPLICATION SLAVE ON *.* TO 'replica'@'$IP_ADDRESS'; FLUSH PRIVILEGES;"
sleep 30

# Configurar el esclavo con la información del maestro
docker exec mysql-slave mysql -uroot -ptoor -e "CHANGE MASTER TO MASTER_HOST='$IP_ADDRESS', MASTER_USER='replica', MASTER_PASSWORD='123', MASTER_LOG_FILE='$CURRENT_LOG', MASTER_LOG_POS=$CURRENT_POS; START SLAVE;"
# Mostrar el estado del esclavo
docker exec mysql-slave mysql -uroot -ptoor -e "SHOW SLAVE STATUS \G"

sleep 10


# STOP SLAVE;CHANGE MASTER TO MASTER_HOST='172.21.0.3', MASTER_USER='replica', MASTER_PASSWORD='123', MASTER_LOG_FILE='binlog.000012', MASTER_LOG_POS=1061; START SLAVE;
