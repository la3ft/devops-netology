# Домашнее задание к занятию "13.4 инструменты для упрощения написания конфигурационных файлов. Helm и Jsonnet"
В работе часто приходится применять системы автоматической генерации конфигураций. Для изучения нюансов использования разных инструментов нужно попробовать упаковать приложение каждым из них.

## Задание 1: подготовить helm чарт для приложения
Необходимо упаковать приложение в чарт для деплоя в разные окружения. Требования:
* каждый компонент приложения деплоится отдельным deployment’ом/statefulset’ом;
* в переменных чарта измените образ приложения для изменения версии.

## Задание 2: запустить 2 версии в разных неймспейсах
Подготовив чарт, необходимо его проверить. Попробуйте запустить несколько копий приложения:
* одну версию в namespace=app1;
* вторую версию в том же неймспейсе;
* третью версию в namespace=app2.

## Ответы:

### 1. Создадим чарт:
```
/13-kubernetes-config-04-helm$ helm create front-back-db
Creating front-back-db
```
Добавим описания в созданной папке `front-back-db/templates/` для каждого компонента по отдельности:  
Службы:  
[frontend.yaml](front-back-db/templates/frontend.yaml)  
[backend.yaml](front-back-db/templates/backend.yaml)  
[db.yaml](front-back-db/templates/db.yaml)  

Деплоймент и БД:  
[deployment.yaml](front-back-db/templates/deployment.yaml)  
[statefulset.yaml](front-back-db/templates/statefulset.yaml)  

Изменим файл переменных `front-back-db/values.yaml` - [values](front-back-db/values.yaml)  
Проверим lint'ом:
```
/13-kubernetes-config-04-helm# helm lint front-back-db/
==> Linting front-back-db/
[INFO] Chart.yaml: icon is recommended

1 chart(s) linted, 0 chart(s) failed
```
Запишем манифест на основе созданного нами шаблона
```
/13-kubernetes-config-04-helm# helm template front-back-db > front-back-db.yaml
```
  
[front-back-db.yaml](front-back-db.yaml)  

Проверим работу созданного файла:  
```
/13-kubernetes-config-04-helm# kubectl apply -f front-back-db.yaml
service/backend created
service/db created
service/frontend created
deployment.apps/backend created
deployment.apps/frontend created
statefulset.apps/db created
pod/release-name-front-back-db-test-connection created

/13-kubernetes-config-04-helm# kubectl get po
NAME                                         READY   STATUS    RESTARTS   AGE
backend-5b9c8865fd-rn5lm                     1/1     Running   0          6s
db-0                                         1/1     Running   0          6s
frontend-7745ccb64f-mvvbm                    1/1     Running   0          6s
release-name-front-back-db-test-connection   0/1     Error     0          6s
```

### 2. Создадим нэймспейсы:
```
kubectl create namespace app1
kubectl create namespace app2 
```
Установим на app1 и проверим:
```
/13-kubernetes-config-04-helm# helm install r1 --set namespace=app1 front-back-db
NAME: r1
LAST DEPLOYED: Sat Mar 18 15:37:52 2023
NAMESPACE: default
STATUS: deployed
REVISION: 1

/13-kubernetes-config-04-helm# kubectl get po -n app1
NAME                        READY   STATUS    RESTARTS   AGE
backend-5b9c8865fd-h9wc4    1/1     Running   0          5m32s
db-0                        1/1     Running   0          5m32s
frontend-7745ccb64f-g88qp   1/1     Running   0          5m32s
```
  
Попробуем поставить в том же нэймспейсе:
```
/13-kubernetes-config-04-helm# helm install r2 --set namespace=app1 front-bac
k-db
Error: INSTALLATION FAILED: rendered manifests contain a resource that already exists. Unable to continue with install: Service "backend" in namespace "app1" exists and cannot be imported into the current release: invalid ownership metadata; annotation validation error: key "meta.helm.sh/release-name" must equal "r2": current value is "r1"
```
  
Сделаем апдгрейд:
```
/13-kubernetes-config-04-helm# helm upgrade r1 --set namespace=app1 front-bac
k-db
Release "r1" has been upgraded. Happy Helming!
NAME: r1
LAST DEPLOYED: Sat Mar 18 15:46:56 2023
NAMESPACE: default
STATUS: deployed
REVISION: 2

/13-kubernetes-config-04-helm# kubectl get po -n app1
NAME                        READY   STATUS    RESTARTS   AGE
backend-5b9c8865fd-h9wc4    1/1     Running   0          9m39s
db-0                        1/1     Running   0          9m39s
frontend-7745ccb64f-g88qp   1/1     Running   0          9m39s

/13-kubernetes-config-04-helm# helm list
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                  APP VERSION
r1      default         2               2023-03-18 15:46:56.742023368 +0000 UTC deployed        front-back-db-0.1.0    1.16.0
```
  
Установим на неймспейс app2:
```
/13-kubernetes-config-04-helm# helm install r2 --set namespace=app2 front-back-db
NAME: r2e1
LAST DEPLOYED: Sat Mar 18 15:48:57 2023
NAMESPACE: default
STATUS: deployed
REVISION: 1

/13-kubernetes-config-04-helm# kubectl get po -n app2
NAME                        READY   STATUS    RESTARTS   AGE
backend-5b9c8865fd-5vj6j    1/1     Running   0          47s
db-0                        1/1     Running   0          47s
frontend-7745ccb64f-877h8   1/1     Running   0          47s

/13-kubernetes-config-04-helm# helm list
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
r1      default         2               2023-03-18 15:46:56.742023368 +0000 UTC deployed        front-back-db-0.1.0     1.16.0
r2      default         1               2023-03-18 15:48:57.442657665 +0000 UTC deployed        front-back-db-0.1.0     1.16.0
```
