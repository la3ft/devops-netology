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
root@node1:/home/laft/manifests# kubectl create -f front_and_back.yaml
deployment.apps/front-and-back created
root@node1:/home/laft/manifests# kubectl create -f DB.yaml
statefulset.apps/db-01 created
```
### 2. Создадим общий файл конфигурации с описанием деплойментов и сервисов к ним:

```

```
