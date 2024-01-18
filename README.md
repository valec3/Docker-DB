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

mysql -h 172.20.0.0 -P 4406 -u slave -p


### Ver estado del master
```SQL
SHOW MASTER STATUS;
```
### Configurar slave
```SQL
CHANGE MASTER TO
  MASTER_HOST = '172.19.0.3',
  MASTER_USER = 'replica',
  MASTER_PASSWORD = '123',
  MASTER_LOG_FILE = 'binlog.000017',
  MASTER_LOG_POS = 851;
```








### HELPS 

ver usuarios
```SQL
SELECT user, host FROM mysql.user;
```
Crear usuario de replica:
```SQL
CREATE USER 'replica'@'172.19.0.3' IDENTIFIED WITH 'mysql_native_password' BY '123';
GRANT REPLICATION SLAVE ON *.* TO 'replica'@'172.19.0.3';
FLUSH PRIVILEGES;
```

config master my.cnf
```bash
default_authentication_plugin = mysql_native_password

server-id = 1
log_bin = /var/log/mysql/mysql-bin.log
log_bin = 1
```

config slave my.cnf
```bash
default_authentication_plugin = mysql_native_password
server-id = 2
log_bin = /var/log/mysql/mysql-bin.log
```

```SQL
ALTER USER 'replica'@'172.19.0.2' IDENTIFIED WITH 'mysql_native_password' BY '123';
```



### Codigo SQL

```SQL

-- Crear tabla en base de datos local
CREATE TABLE central (
  id INT PRIMARY KEY,
  nombre VARCHAR(50),
  descripcion TEXT
);

-- Crear una tabla en la base de datos remota
CREATE TABLE remota (
  id INT PRIMARY KEY,
  detalle VARCHAR(50),
  cantidad INT
);


-- Insertar datos de ejemplo en la tabla central
INSERT INTO central (id, nombre, descripcion) VALUES
(1, 'Producto A', 'Descripción del Producto A'),
(2, 'Producto B', 'Descripción del Producto B'),
(3, 'Producto C', 'Descripción del Producto C');

-- Insertar datos de ejemplo en la tabla remota
INSERT INTO remota (id, detalle, cantidad) VALUES
(1, 'Detalle 1', 10),
(2, 'Detalle 2', 15),
(3, 'Detalle 3', 20);

```

```SQL
-- Crear un procedimiento almacenado para recuperar datos de ambas bases de datos
DELIMITER //
CREATE OR REPLACE PROCEDURE obtener_datos_distribuidos()
BEGIN
  DECLARE id INT;
  DECLARE nombre VARCHAR(50);
  DECLARE descripcion TEXT;
  DECLARE detalle VARCHAR(50);
  DECLARE cantidad INT;

  -- Obtener datos de la base de datos central
  SELECT id, nombre, descripcion INTO id, nombre, descripcion FROM central WHERE id = 1;

  -- Obtener datos de la base de datos remota
  SELECT detalle, cantidad INTO detalle, cantidad FROM remota WHERE id = 1;

  -- Imprimir los resultados
  SELECT id, nombre, descripcion, detalle, cantidad;

END //
DELIMITER ;

```

```SQL
-- Ejecutar el procedimiento almacenado
CALL obtener_datos_distribuidos();

DROP PROCEDURE IF EXISTS obtener_datos_distribuidos;

```

```SQL

DELIMITER //
CREATE PROCEDURE obtener_datos_distribuidos()
BEGIN
  DECLARE id INT;
  DECLARE nombre VARCHAR(50);
  DECLARE descripcion TEXT;
  DECLARE detalle VARCHAR(50);
  DECLARE cantidad INT;

  -- Obtener datos de la base de datos central
  SELECT id, nombre, descripcion INTO id, nombre, descripcion FROM central WHERE id = 1;

  -- Obtener datos de la base de datos remota
  SELECT detalle, cantidad INTO detalle, cantidad FROM remota WHERE id = 1;

  -- Imprimir los resultados
  SELECT id, nombre, descripcion, detalle, cantidad;

END //
DELIMITER ;
```