INSTANCE_ID=$(docker ps -qf "name=mysql-master")

# Obtener la dirección IP del contenedor utilizando docker inspect
IP_ADDRESS=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $INSTANCE_ID)

# Imprimir la dirección IP
echo "La ID es: $IP_ADDRESS"

sleep 5