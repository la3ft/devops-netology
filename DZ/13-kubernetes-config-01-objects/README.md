# Домашнее задание к занятию "13.1 контейнеры, поды, deployment, statefulset, services, endpoints"
Настроив кластер, подготовьте приложение к запуску в нём. Приложение стандартное: бекенд, фронтенд, база данных. Его можно найти в папке 13-kubernetes-config.

## Задание 1: подготовить тестовый конфиг для запуска приложения
Для начала следует подготовить запуск приложения в stage окружении с простыми настройками. Требования:
* под содержит в себе 2 контейнера — фронтенд, бекенд;
* регулируется с помощью deployment фронтенд и бекенд;
* база данных — через statefulset.

## Задание 2: подготовить конфиг для production окружения
Следующим шагом будет запуск приложения в production окружении. Требования сложнее:
* каждый компонент (база, бекенд, фронтенд) запускаются в своем поде, регулируются отдельными deployment’ами;
* для связи используются service (у каждого компонента свой);
* в окружении фронта прописан адрес сервиса бекенда;
* в окружении бекенда прописан адрес сервиса базы данных.

## Ответы:
### 1. Создадим образы с указанных Dockerfile и закинем их в нашу репу на dockerhub:
```
...13-kubernetes-config/backend# docker build -t netology-back .
docker run -d --name netology-back netology-back
docker commit b2b049f342ab la3ft/netology-back
docker image push la3ft/netology-back
...13-kubernetes-config/frontend# docker build -t netology-front .
docker run -d --name netology-front netology-front
docker commit 198330b8d64f la3ft/netology-front
docker image push la3ft/netology-front
```

https://hub.docker.com/repository/docker/la3ft/netology-back/general
https://hub.docker.com/repository/docker/la3ft/netology-front/general

Напишем yaml-файл для deployment(front_and_back.yaml) :
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: front-and-back
  labels:
    app: front-back
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: front-back
  template:
    metadata:
      labels:
        app: front-back
    spec:
      containers:
      - name: frontend
        image: la3ft/netology-front
        ports:
        - containerPort: 80
      - name: backend
        image: la3ft/netology-back
        ports:
        - containerPort: 9000
```
  
Напишем yaml-файл для statefulset(DB.yaml) :
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: db-01
spec:
  selector:
    matchLabels:
      app: db
  serviceName: "db-postgres"
  replicas: 1
  template:
    metadata:
      labels:
        app: db
    spec:
      terminationGracePeriodSeconds: 10
      containers:
      - name: db
        image: postgres:14-alpine
        ports:
        - containerPort: 5432
        env:
          - name: POSTGRES_PASSWORD
            value: postgres
          - name: POSTGRES_USER
            value: postgres
          - name: POSTGRES_DB
            value: news
```
Применим написанную нами конфигурацию:
```
root@node1:/home/vagrant/manifests# kubectl create -f front_and_back.yaml
deployment.apps/front-and-back created
root@node1:/home/vagrant/manifests# kubectl create -f DB.yaml
statefulset.apps/db-01 created
```
Проверим работу:
```
root@node1:/home/vagrant/manifests# kubectl get po
NAME                              READY   STATUS    RESTARTS   AGE
db-01-0                           1/1     Running   0          11s
front-and-back-6cb88c57cd-ht46t   2/2     Running   0          7s
```
Удалим созданное:
```
root@node1:/home/vagrant/manifests# kubectl delete -f front_and_back.yaml
deployment.apps "front-and-back" deleted
root@node1:/home/vagrant/manifests# kubectl delete -f DB.yaml
statefulset.apps "db-01" deleted
```

### 2. Создадим общий файл конфигурации с описанием деплойментов и сервисов к ним:
[prod.yaml](https://github.com/la3ft/devops-netology/blob/main/DZ/13-kubernetes-config-01-objects/manifests/prod.yaml)  
Применим написанную нами конфигурацию:
```
root@node1:/home/vagrant/manifests# kubectl create -f prod.yaml
statefulset.apps/db-01 created
service/db-postgres created
deployment.apps/backend-01 created
service/backend-srv created
deployment.apps/frontend-dpl created
service/frontend-srv created
```
  
Проверим работу:
```
root@node1:/home/vagrant/manifests# kubectl get all
NAME                                READY   STATUS    RESTARTS   AGE
pod/backend-01-8666db7c4c-pkcxm     1/1     Running   0          2m8s
pod/db-01-0                         1/1     Running   0          2m8s
pod/frontend-dpl-5dc795b97b-z444g   1/1     Running   0          2m8s

NAME                   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/backend-srv    ClusterIP   10.233.30.114   <none>        9000/TCP   2m8s
service/db-postgres    ClusterIP   10.233.32.177   <none>        5432/TCP   2m13s
service/frontend-srv   ClusterIP   10.233.42.76    <none>        8000/TCP   2m8s
service/kubernetes     ClusterIP   10.233.0.1      <none>        443/TCP    16m

NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/backend-01     1/1     1            1           2m8s
deployment.apps/frontend-dpl   1/1     1            1           2m8s

NAME                                      DESIRED   CURRENT   READY   AGE
replicaset.apps/backend-01-8666db7c4c     1         1         1       2m8s
replicaset.apps/frontend-dpl-5dc795b97b   1         1         1       2m8s

NAME                     READY   AGE
statefulset.apps/db-01   1/1     2m13s
```
