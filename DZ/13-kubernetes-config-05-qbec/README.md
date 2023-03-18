# Домашнее задание к занятию "13.5 поддержка нескольких окружений на примере Qbec"
Приложение обычно существует в нескольких окружениях. Для удобства работы следует использовать соответствующие инструменты, например, Qbec.

## Задание 1: подготовить приложение для работы через qbec
Приложение следует упаковать в qbec. Окружения должно быть 2: stage и production. 

Требования:
* stage окружение должно поднимать каждый компонент приложения в одном экземпляре;
* production окружение — каждый компонент в трёх экземплярах;
* для production окружения нужно добавить endpoint на внешний адрес.

## Ответ:

<<<<<<< HEAD
### 1. 
=======
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
>>>>>>> b51c89c3b90e07a62504a5e876abf9478ed45817
