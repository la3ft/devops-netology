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
[endpoint.jsonnet](front-back-db/components/endpoint.jsonnet)  
  
Создадим файлы окружения:  
[stage.libsonnet](front-back-db/environments/stage.libsonnet)  
[prod.libsonnet](front-back-db/environments/prod.libsonnet)  
  
Отредактируем qbec.yaml с описанием неймспейсов:  
[qbec.yaml](front-back-db/qbec.yaml)  
  
Создадим ns и запустим наш stage:
```
kubectl create ns stage
kubectl create ns prod

/13-kubernetes-config-05-qbec/front-back-db# qbec apply stage
setting cluster to cluster.local
setting context to kubernetes-admin@cluster.local
cluster metadata load took 21ms
3 components evaluated in 9ms

will synchronize 6 object(s)

Do you want to continue [y/n]: y
3 components evaluated in 6ms
create deployments backend -n stage (source backend)
create deployments frontend -n stage (source frontend)
create statefulsets db -n stage (source db)
create services backend -n stage (source backend)
create services db -n stage (source db)
create services frontend -n stage (source frontend)
server objects load took 203ms
---
stats:
  created:
  - deployments backend -n stage (source backend)
  - deployments frontend -n stage (source frontend)
  - statefulsets db -n stage (source db)
  - services backend -n stage (source backend)
  - services db -n stage (source db)
  - services frontend -n stage (source frontend)

waiting for readiness of 3 objects
  - deployments backend -n stage
  - deployments frontend -n stage
  - statefulsets db -n stage

  0s    : deployments frontend -n stage :: 0 of 1 updated replicas are available
  0s    : deployments backend -n stage :: 0 of 1 updated replicas are available
✓ 0s    : statefulsets db -n stage :: 1 new pods updated (2 remaining)
✓ 0s    : deployments backend -n stage :: successfully rolled out (1 remaining)
✓ 0s    : deployments frontend -n stage :: successfully rolled out (0 remaining)

✓ 0s: rollout complete
command took 3.45s

/13-kubernetes-config-05-qbec/front-back-db# kubectl get po -n stage
NAME                        READY   STATUS    RESTARTS   AGE
backend-57cdbfb5dd-kdz6h    1/1     Running   0          27s
db-0                        1/1     Running   0          27s
frontend-5fbc4d87c9-7xc7v   1/1     Running   0          27s
```  
  
Запустим prod и проверим количество реплик на выходе:
```
/13-kubernetes-config-05-qbec/front-back-db# qbec apply prod
setting cluster to cluster.local
setting context to kubernetes-admin@cluster.local
cluster metadata load took 16ms
4 components evaluated in 12ms

will synchronize 7 object(s)

Do you want to continue [y/n]: y
4 components evaluated in 13ms
create endpoints frontend -n prod (source endpoint)
create deployments backend -n prod (source backend)
create deployments frontend -n prod (source frontend)
create statefulsets db -n prod (source db)
create services backend -n prod (source backend)
create services db -n prod (source db)
create services frontend -n prod (source frontend)
server objects load took 609ms
---
stats:
  created:
  - endpoints frontend -n prod (source endpoint)
  - deployments backend -n prod (source backend)
  - deployments frontend -n prod (source frontend)
  - statefulsets db -n prod (source db)
  - services backend -n prod (source backend)
  - services db -n prod (source db)
  - services frontend -n prod (source frontend)

waiting for readiness of 3 objects
  - deployments backend -n prod
  - deployments frontend -n prod
  - statefulsets db -n prod

  0s    : statefulsets db -n prod :: 1 of 3 updated
  0s    : deployments backend -n prod :: 2 of 3 updated replicas are available
  0s    : deployments frontend -n prod :: 1 of 3 updated replicas are available
  1s    : deployments frontend -n prod :: 2 of 3 updated replicas are available
✓ 1s    : deployments frontend -n prod :: successfully rolled out (2 remaining)
  1s    : statefulsets db -n prod :: 2 of 3 updated
✓ 1s    : deployments backend -n prod :: successfully rolled out (1 remaining)
✓ 3s    : statefulsets db -n prod :: 3 new pods updated (0 remaining)

✓ 3s: rollout complete
command took 6.98s

/13-kubernetes-config-05-qbec/front-back-db# kubectl -n prod get po -o wide
NAME                        READY   STATUS    RESTARTS   AGE   IP             NODE    NOMINATED NODE   READINESS GATES
backend-57cdbfb5dd-fl5kg    1/1     Running   0          93s   10.233.75.15   node2   <none>           <none>
backend-57cdbfb5dd-vrz9v    1/1     Running   0          93s   10.233.71.13   node3   <none>           <none>
backend-57cdbfb5dd-z26zc    1/1     Running   0          93s   10.233.75.17   node2   <none>           <none>
db-0                        1/1     Running   0          92s   10.233.75.18   node2   <none>           <none>
db-1                        1/1     Running   0          90s   10.233.71.16   node3   <none>           <none>
db-2                        1/1     Running   0          88s   10.233.75.19   node2   <none>           <none>
frontend-5fbc4d87c9-8dlj2   1/1     Running   0          93s   10.233.75.16   node2   <none>           <none>
frontend-5fbc4d87c9-8nqxb   1/1     Running   0          93s   10.233.71.15   node3   <none>           <none>
frontend-5fbc4d87c9-964jd   1/1     Running   0          93s   10.233.71.14   node3   <none>           <none>
```
