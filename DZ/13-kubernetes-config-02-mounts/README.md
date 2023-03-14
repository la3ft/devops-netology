# Домашнее задание к занятию "13.2 разделы и монтирование"
Приложение запущено и работает, но время от времени появляется необходимость передавать между бекендами данные. А сам бекенд генерирует статику для фронта. Нужно оптимизировать это.
Для настройки NFS сервера можно воспользоваться следующей инструкцией (производить под пользователем на сервере, у которого есть доступ до kubectl):
* установить helm: curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
* добавить репозиторий чартов: helm repo add stable https://charts.helm.sh/stable && helm repo update
* установить nfs-server через helm: helm install nfs-server stable/nfs-server-provisioner

В конце установки будет выдан пример создания PVC для этого сервера.

## Задание 1: подключить для тестового конфига общую папку
В stage окружении часто возникает необходимость отдавать статику бекенда сразу фронтом. Проще всего сделать это через общую папку. Требования:
* в поде подключена общая папка между контейнерами (например, /static);
* после записи чего-либо в контейнере с беком файлы можно получить из контейнера с фронтом.

## Задание 2: подключить общую папку для прода
Поработав на stage, доработки нужно отправить на прод. В продуктиве у нас контейнеры крутятся в разных подах, поэтому потребуется PV и связь через PVC. Сам PV должен быть связан с NFS сервером. Требования:
* все бекенды подключаются к одному PV в режиме ReadWriteMany;
* фронтенды тоже подключаются к этому же PV с таким же режимом;
* файлы, созданные бекендом, должны быть доступны фронту.

## Ответы:

### 1. Изменим наш деплоймент файл из прошлого задания для использования volume - [front_and_back.yaml](https://github.com/la3ft/devops-netology/blob/main/DZ/13-kubernetes-config-02-mounts/manifests/front_and_back.yaml).  
Применим:
```
/manifests# kubectl create -f front_and_back.yaml
```
Проверим создание в контейнере backend:
```
/manifests# kubectl exec front-and-back-6c4698c86b-p9gf8 -c backend -- sh -c "echo 'test' > /static/test.txt"
```
Проверим доступность в контейнере frontend:
```
/manifests# kubectl exec front-and-back-6c4698c86b-p9gf8 -c frontend -- cat /static/test.txt
test
```

### 2. Установить nfs-server из описания в шапке выше:
```
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
helm repo add stable https://charts.helm.sh/stable && helm repo update
helm install nfs-server stable/nfs-server-provisioner
```
Дополнить наш манифест для прода из предыдущего задания описанием PVC и volume для frontend и backend [prod.yaml](https://github.com/la3ft/devops-netology/blob/main/DZ/13-kubernetes-config-02-mounts/manifests/prod.yaml)  
Применить и проверить запуск:
```
/manifests# kubectl apply -f prod.yaml
persistentvolumeclaim/nfs-pvc created
statefulset.apps/db-01 created
service/db-postgres created
deployment.apps/backend-01 created
service/backend-srv created
deployment.apps/frontend-dpl created
service/frontend-srv created

/manifests# kubectl get po
NAME                                  READY   STATUS    RESTARTS   AGE
backend-01-6f5f98f77b-64pn7           1/1     Running   0          4m15s
db-01-0                               1/1     Running   0          4m15s
frontend-dpl-5bfd55d8c7-rspqj         1/1     Running   0          4m14s
nfs-server-nfs-server-provisioner-0   1/1     Running   0          4m47s
```
Посмотрим на созданный том:
```
/manifests# kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM             STORAGECLASS   REASON   AGE
pvc-12d933cb-2f28-4dd9-9f76-4aa0d6d25eca   1Gi        RWX            Delete           Bound    default/nfs-pvc   nfs
```
