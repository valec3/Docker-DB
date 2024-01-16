# COMANDOS
## CREAR CONTENEDORES

### Iniciar docker master
```bash
docker-compose up -d
```
### Iniciar docker slave
```bash
docker-compose -f docker-compose-slave.yml up -d
```

### Ver estado del master
```SQL
SHOW MASTER STATUS;
```
### Configurar slave
```SQL
CHANGE MASTER TO
  MASTER_HOST = '172.20.0.2',
  MASTER_USER = 'replica',
  MASTER_PASSWORD = '123',
  MASTER_LOG_FILE = 'binlog.000003',
  MASTER_LOG_POS = 1342;
```








### HELPS 

ver usuarios
```SQL
SELECT user, host FROM mysql.user;
```
Crear usuario de replica:
```SQL
CREATE USER 'replica'@'172.20.0.2' IDENTIFIED BY '123';
GRANT REPLICATION SLAVE ON *.* TO 'replica'@'172.20.0.2';
FLUSH PRIVILEGES;
```

config master my.cnf
```bash
bind_address = 172.20.0.2
server-id = 1
log_bin = /var/log/mysql/mysql-bin.log
```

config slave my.cnf
```bash
server-id = 2
log_bin = /var/log/mysql/mysql-bin.log
```

```SQL
ALTER USER 'replica'@'172.20.0.2' IDENTIFIED WITH 'mysql_native_password' BY 'tu_nueva_contraseña';
```