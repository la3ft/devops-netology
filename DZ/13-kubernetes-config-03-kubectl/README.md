# Домашнее задание к занятию "13.3 работа с kubectl"
## Задание 1: проверить работоспособность каждого компонента
Для проверки работы можно использовать 2 способа: port-forward и exec. Используя оба способа, проверьте каждый компонент:
* сделайте запросы к бекенду;
* сделайте запросы к фронту;
* подключитесь к базе данных.

## Задание 2: ручное масштабирование

При работе с приложением иногда может потребоваться вручную добавить пару копий. Используя команду kubectl scale, попробуйте увеличить количество бекенда и фронта до 3. Проверьте, на каких нодах оказались копии после каждого действия (kubectl describe, kubectl get pods -o wide). После уменьшите количество копий до 1.

## Ответы:

### 1. Продолжаем использовать наш деплоймент из предыдущих заданий [prod](https://github.com/la3ft/devops-netology/blob/main/DZ/13-kubernetes-config-01-objects/manifests/prod.yaml)  

Сделаем port-forward для backend и frontend, проверим его:
```
root@node1:/home/vagrant# kubectl port-forward pods/backend-01-8666db7c4c-znnwv 9090:9000
Forwarding from 127.0.0.1:9090 -> 9000
Forwarding from [::1]:9090 -> 9000

root@node1:/home/vagrant# curl 127.0.0.1:9090
{"detail":"Not Found"}root@node1:/home/vagrant#
```
```
root@node1:/home/vagrant# kubectl port-forward pods/frontend-01-5dc795b97b-wbvxh 8080:80
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
Handling connection for 8080

root@node1:/home/vagrant# curl 127.0.0.1:8080
<!DOCTYPE html>
<html lang="ru">
<head>
    <title>Список</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/build/main.css" rel="stylesheet">
</head>
<body>
    <main class="b-page">
        <h1 class="b-page__title">Список</h1>
        <div class="b-page__content b-items js-list"></div>
    </main>
    <script src="/build/main.js"></script>
</body>
```  

Теперь подключимся к БД:  
```
root@node1:/home/vagrant# kubectl exec -ti db-01-0 -- /bin/sh
/ # su postgres
/ $ psql -h localhost
psql (14.7)
Type "help" for help.

postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 news      | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(4 rows)
```
### 2. Увеличим с помощью команды scale:
```
root@node1:/home/vagrant# kubectl scale --replicas=3 deployment/frontend-01
deployment.apps/frontend-01 scaled
root@node1:/home/vagrant# kubectl scale --replicas=3 deployment/backend-01
deployment.apps/backend-01 scaled
```  
Проверим расширенный вывод чтобы увидеть расположение на нодах:
```
root@node1:/home/vagrant# kubectl get po -o wide
NAME                           READY   STATUS    RESTARTS   AGE    IP            NODE    NOMINATED NODE   READINESS GATES
backend-01-8666db7c4c-lqhf7    1/1     Running   0          53s    10.233.71.5   node3   <none>           <none>
backend-01-8666db7c4c-snsvt    1/1     Running   0          53s    10.233.75.8   node2   <none>           <none>
backend-01-8666db7c4c-znnwv    1/1     Running   0          109m   10.233.71.3   node3   <none>           <none>
db-01-0                        1/1     Running   0          109m   10.233.75.5   node2   <none>           <none>
frontend-01-5dc795b97b-hg8p6   1/1     Running   0          67s    10.233.75.7   node2   <none>           <none>
frontend-01-5dc795b97b-q92ks   1/1     Running   0          67s    10.233.71.4   node3   <none>           <none>
frontend-01-5dc795b97b-wbvxh   1/1     Running   0          109m   10.233.75.6   node2   <none>           <none>
```  
Уменьшим и также посмотрим вывод подов:
```
root@node1:/home/vagrant# kubectl scale --replicas=1 deployment/backend-01
deployment.apps/backend-01 scaled
root@node1:/home/vagrant# kubectl scale --replicas=1 deployment/frontend-01
deployment.apps/frontend-01 scaled

root@node1:/home/vagrant# kubectl get po -o wide
NAME                           READY   STATUS    RESTARTS   AGE     IP            NODE    NOMINATED NODE   READINESS GATES
backend-01-8666db7c4c-snsvt    1/1     Running   0          2m56s   10.233.75.8   node2   <none>           <none>
db-01-0                        1/1     Running   0          111m    10.233.75.5   node2   <none>           <none>
frontend-01-5dc795b97b-q92ks   1/1     Running   0          3m10s   10.233.71.4   node3   <none>           <none>
```
