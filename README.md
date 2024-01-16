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
  MASTER_HOST = '172.19.0.2',
  MASTER_USER = 'slave',
  MASTER_PASSWORD = '123',
  MASTER_LOG_FILE = 'binlog.000002',
  MASTER_LOG_POS = 4708;
```








### HELPS 

ver usuarios
```SQL
SELECT user, host FROM mysql.user;
```
Crear usuario de replica:
```SQL
CREATE USER 'replica'@'172.19.0.1' IDENTIFIED BY '123';
GRANT REPLICATION SLAVE ON *.* TO 'replica'@'172.19.0.1';
FLUSH PRIVILEGES;
```

config master my.cnf
```bash
bind_address = 172.19.0.2
server-id = 1
log_bin = /var/log/mysql/mysql-bin.log
```

config slave my.cnf
```bash
server-id = 2
log_bin = /var/log/mysql/mysql-bin.log
```