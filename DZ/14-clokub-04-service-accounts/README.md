# Домашнее задание к занятию "14.4 Сервис-аккаунты"

## Задача 1: Работа с сервис-аккаунтами через утилиту kubectl в установленном minikube

Выполните приведённые команды в консоли. Получите вывод команд. Сохраните
задачу 1 как справочный материал.

### Как создать сервис-аккаунт?

```
kubectl create serviceaccount netology
```

### Как просмотреть список сервис-акаунтов?

```
kubectl get serviceaccounts
kubectl get serviceaccount
```

### Как получить информацию в формате YAML и/или JSON?

```
kubectl get serviceaccount netology -o yaml
kubectl get serviceaccount default -o json
```

### Как выгрузить сервис-акаунты и сохранить его в файл?

```
kubectl get serviceaccounts -o json > serviceaccounts.json
kubectl get serviceaccount netology -o yaml > netology.yml
```

### Как удалить сервис-акаунт?

```
kubectl delete serviceaccount netology
```

### Как загрузить сервис-акаунт из файла?

```
kubectl apply -f netology.yml
```


## Ответ:

### 1. Листинг:
Создание сервис-аккаунта:
```
root@node1:/home/vagrant# kubectl create serviceaccount netology
serviceaccount/netology created
```  
Вывод сервис-аккаунтов:
```
root@node1:/home/vagrant# kubectl get serviceaccounts
NAME       SECRETS   AGE
default    0         19m
netology   0         45s

root@node1:/home/vagrant# kubectl get serviceaccount
NAME       SECRETS   AGE
default    0         20m
netology   0         77s
```  
Вывод в форматах yaml, json:
```
root@node1:/home/vagrant# kubectl get serviceaccount netology -o yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  creationTimestamp: "2023-04-17T17:31:12Z"
  name: netology
  namespace: default
  resourceVersion: "3000"
  uid: 5d91b413-94eb-4b86-bcc3-6cddb89fb22a

root@node1:/home/vagrant# kubectl get serviceaccount default -o json
{
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
        "creationTimestamp": "2023-04-17T17:12:01Z",
        "name": "default",
        "namespace": "default",
        "resourceVersion": "310",
        "uid": "d970adeb-4962-4527-ba1a-3de51f2d5f67"
    }
}
```  
Запись в файлы:
```
root@node1:/home/vagrant# kubectl get serviceaccounts -o json > serviceaccounts.json
root@node1:/home/vagrant# cat serviceaccounts.json
{
    "apiVersion": "v1",
    "items": [
        {
            "apiVersion": "v1",
            "kind": "ServiceAccount",
            "metadata": {
                "creationTimestamp": "2023-04-17T17:12:01Z",
                "name": "default",
                "namespace": "default",
                "resourceVersion": "310",
                "uid": "d970adeb-4962-4527-ba1a-3de51f2d5f67"
            }
        },
        {
            "apiVersion": "v1",
            "kind": "ServiceAccount",
            "metadata": {
                "creationTimestamp": "2023-04-17T17:31:12Z",
                "name": "netology",
                "namespace": "default",
                "resourceVersion": "3000",
                "uid": "5d91b413-94eb-4b86-bcc3-6cddb89fb22a"
            }
        }
    ],
    "kind": "List",
    "metadata": {
        "resourceVersion": ""
    }
}

root@node1:/home/vagrant# kubectl get serviceaccount netology -o yaml > netology.yml
root@node1:/home/vagrant# cat netology.yml
apiVersion: v1
kind: ServiceAccount
metadata:
  creationTimestamp: "2023-04-17T17:31:12Z"
  name: netology
  namespace: default
  resourceVersion: "3000"
  uid: 5d91b413-94eb-4b86-bcc3-6cddb89fb22a
```  
Удаление сервис-аккаунта:
```
root@node1:/home/vagrant# kubectl delete serviceaccount netology
serviceaccount "netology" deleted
root@node1:/home/vagrant# kubectl get serviceaccounts
NAME      SECRETS   AGE
default   0         22m
```  
Создание из файла:  
```
root@node1:/home/vagrant# kubectl apply -f netology.yml
serviceaccount/netology created
root@node1:/home/vagrant# kubectl get serviceaccounts
NAME       SECRETS   AGE
default    0         23m
netology   0         4s
```
