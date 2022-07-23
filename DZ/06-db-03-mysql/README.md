# Домашнее задание к занятию "6.3. MySQL"


## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.

### Ответ:  
docker-compose:
```yaml
version: "3.9"
services:
  mysql:
    image: mysql:8
    environment:
      MYSQL_ROOT_PASSWORD: "mysql"
    ports:
      - "3306:3306"
    volumes:
      - mysql:/var/lib/mysql/
volumes:
  mysql:
```  
```
root@vagrant:/home/vagrant/mysqldock# docker exec -ti mysqldock-mysql-1 mysql -uroot -p
mysql> CREATE DATABASE test;
mysql> \q
root@vagrant:/home/vagrant/mysqldock# cat /home/vagrant/test_dump.sql | docker exec -i mysqldock-mysql-1 mysql -u root -p mysql test
root@vagrant:/home/vagrant/mysqldock# docker exec -ti mysqldock-mysql-1 mysql -uroot -p
mysql> \h
mysql> \s
--------------
mysql  Ver 8.0.29 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          18
Current database:
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.29 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 41 min 27 sec

Threads: 5  Questions: 134  Slow queries: 0  Opens: 232  Flush tables: 3  Open tables: 150  Queries per second avg: 0.053
--------------
mysql> use test;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+----------------+
| Tables_in_test |
+----------------+
| orders         |
+----------------+
1 row in set (0.00 sec)
mysql> select count(*) from orders where price > 300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)
```

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

### Ответ:  
```
mysql> create user 'test'@'localhost' identified by 'test-pass';
Query OK, 0 rows affected (0.01 sec)

mysql> alter user 'test'@'localhost'
    -> identified by 'test-pass'
    -> with
    -> max_queries_per_hour 100
    -> password expire interval 180 day
    -> failed_login_attempts 3 password_lock_time 2;
Query OK, 0 rows affected (0.01 sec)

mysql> alter user 'test'@'localhost' attribute '{"first_name":"James", "last_name":"Pretty"}';
Query OK, 0 rows affected (0.05 sec)

mysql> grant select on test.orders TO 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> select * from INFORMATION_SCHEMA.USER_ATTRIBUTES where user='test';
+------+-----------+------------------------------------------------+
| USER | HOST      | ATTRIBUTE                                      |
+------+-----------+------------------------------------------------+
| test | localhost | {"last_name": "Pretty", "first_name": "James"} |
+------+-----------+------------------------------------------------+
1 row in set (0.00 sec)
```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

### Ответ:  
```
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> SHOW PROFILES;
Empty set, 1 warning (0.00 sec)

mysql> SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'test';
+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| orders     | InnoDB |
+------------+--------+
1 row in set (0.00 sec)

mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.08 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.10 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW PROFILES;
+----------+------------+--------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                |
+----------+------------+--------------------------------------------------------------------------------------+
|        1 | 0.00093000 | SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'test' |
|        2 | 0.08483625 | ALTER TABLE orders ENGINE = MyISAM                                                   |
|        3 | 0.09219850 | ALTER TABLE orders ENGINE = InnoDB                                                   |
+----------+------------+--------------------------------------------------------------------------------------+
3 rows in set, 1 warning (0.01 sec)
```

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.


### Ответ:  


