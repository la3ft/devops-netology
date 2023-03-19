# Домашнее задание к занятию "13.5 поддержка нескольких окружений на примере Qbec"
Приложение обычно существует в нескольких окружениях. Для удобства работы следует использовать соответствующие инструменты, например, Qbec.

## Задание 1: подготовить приложение для работы через qbec
Приложение следует упаковать в qbec. Окружения должно быть 2: stage и production. 

Требования:
* stage окружение должно поднимать каждый компонент приложения в одном экземпляре;
* production окружение — каждый компонент в трёх экземплярах;
* для production окружения нужно добавить endpoint на внешний адрес.

## Ответ:


### 1. Установим Qbec: 
```
/13-kubernetes-config-05-qbec# wget https://github.com/splunk/qbec/releases/download/v0.15.2/qbec-linux-amd64.tar.gz
/13-kubernetes-config-05-qbec# tar -xzf qbec-linux-amd64.tar.gz -C /home/vagrant/qbec
/13-kubernetes-config-05-qbec# mv /home/vagrant/qbec /usr/local
/13-kubernetes-config-05-qbec# export PATH=$PATH:/usr/local/qbec
```
  
Инициализируем создание структуры папок:
```
/13-kubernetes-config-05-qbec# qbec init front-back-db --with-example
```

Напишем наши компоненты в формате jsonnet `(front-back-db/components/)`:  
[backend.jsonnet](front-back-db/components/backend.jsonnet)  
[db.jsonnet](front-back-db/components/db.jsonnet)  
[frontend.jsonnet](front-back-db/components/frontend.jsonnet)  
  
Создадим файлы окружения:  
[stage.libsonnet](front-back-db/environments/stage.libsonnet)  
[prod.libsonnet](front-back-db/environments/prod.libsonnet)  
