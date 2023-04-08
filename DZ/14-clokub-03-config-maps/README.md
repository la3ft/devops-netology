# Домашнее задание к занятию "14.3 Карты конфигураций"

## Задача 1: Работа с картами конфигураций через утилиту kubectl в установленном minikube

Выполните приведённые команды в консоли. Получите вывод команд. Сохраните
задачу 1 как справочный материал.

### Как создать карту конфигураций?

```
kubectl create configmap nginx-config --from-file=nginx.conf
kubectl create configmap domain --from-literal=name=netology.ru
```

### Как просмотреть список карт конфигураций?

```
kubectl get configmaps
kubectl get configmap
```

### Как просмотреть карту конфигурации?

```
kubectl get configmap nginx-config
kubectl describe configmap domain
```

### Как получить информацию в формате YAML и/или JSON?

```
kubectl get configmap nginx-config -o yaml
kubectl get configmap domain -o json
```

### Как выгрузить карту конфигурации и сохранить его в файл?

```
kubectl get configmaps -o json > configmaps.json
kubectl get configmap nginx-config -o yaml > nginx-config.yml
```

### Как удалить карту конфигурации?

```
kubectl delete configmap nginx-config
```

### Как загрузить карту конфигурации из файла?

```
kubectl apply -f nginx-config.yml
```

## Ответ:

### 1. Листинг:
```
/14-clokub-03-config-maps# kubectl create configmap nginx-config --from-file=nginx.conf
configmap/nginx-config created

/14-clokub-03-config-maps# kubectl create configmap domain --from-literal=name=netology.ru
configmap/domain created

/14-clokub-03-config-maps# kubectl get configmaps
NAME               DATA   AGE
domain             1      17s
kube-root-ca.crt   1      19m
nginx-config       1      22s

/14-clokub-03-config-maps# kubectl get configmap
NAME               DATA   AGE
domain             1      23s
kube-root-ca.crt   1      19m
nginx-config       1      28s

/14-clokub-03-config-maps# kubectl get configmap nginx-config
NAME           DATA   AGE
nginx-config   1      37s

/14-clokub-03-config-maps# kubectl describe configmap domain
Name:         domain
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
name:
----
netology.ru

BinaryData
====

Events:  <none>
/14-clokub-03-config-maps# kubectl get configmap nginx-config -o yaml
apiVersion: v1
data:
  nginx.conf: |
    server {
        listen 80;
        server_name  netology.ru www.netology.ru;
        access_log  /var/log/nginx/domains/netology.ru-access.log  main;
        error_log   /var/log/nginx/domains/netology.ru-error.log info;
        location / {
            include proxy_params;
            proxy_pass http://10.10.10.10:8080/;
        }
    }
kind: ConfigMap
metadata:
  creationTimestamp: "2023-04-08T13:56:28Z"
  name: nginx-config
  namespace: default
  resourceVersion: "2895"
  uid: f7aa504f-2160-4be6-9555-780151562ad5
  
/14-clokub-03-config-maps# kubectl get configmap domain -o json
{
    "apiVersion": "v1",
    "data": {
        "name": "netology.ru"
    },
    "kind": "ConfigMap",
    "metadata": {
        "creationTimestamp": "2023-04-08T13:56:33Z",
        "name": "domain",
        "namespace": "default",
        "resourceVersion": "2904",
        "uid": "0c9fafa4-acfd-474b-b0cf-7912d67d23d7"
    }
}

/14-clokub-03-config-maps# kubectl get configmaps -o json > configmaps.json

/14-clokub-03-config-maps# cat configmaps.json
{
    "apiVersion": "v1",
    "items": [
        {
            "apiVersion": "v1",
            "data": {
                "name": "netology.ru"
            },
            "kind": "ConfigMap",
            "metadata": {
                "creationTimestamp": "2023-04-08T13:56:33Z",
                "name": "domain",
                "namespace": "default",
                "resourceVersion": "2904",
                "uid": "0c9fafa4-acfd-474b-b0cf-7912d67d23d7"
            }
        },
        {
            "apiVersion": "v1",
            "data": {
                "ca.crt": "-----BEGIN CERTIFICATE-----\nMIIC/jCCAeagAwIBAgIBADANBgkqhkiG9w0BAQsFADAVMRMwEQYDVQQDEwprdWJl\ncm5ldGVzMB4XDTIzMDQwODEzMzcxNFoXDTMzMDQwNTEzMzcxNFowFTETMBEGA1UE\nAxMKa3ViZXJuZXRlczCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJdC\n0HaFVjNRtJeFW9eQLvp30xtpuMPaPbnqfgTegNeercQQ75UgGPMrzrbiA46T7bFv\nMwob6omSaBA/ZiKMRmsfkQFcoKjlVz35KJqxmoJW0CBpvT9nz+qsBQvrKJ7kC8Fj\nT03Ne148zLgovSKIj1ojmm9vk3JnFVpdmxJu9sMhfNHL/aeXD+Aaq8bD9r6g6AEK\nzvHsZxXGWRqRPTgoOkJ9s95VDbglNnxzgdt45QtQet25VMhwwzRXw0AJMK7O3x5M\nnhQggIYYq2aqyhWSeCdCkTzz/yZjIVKI2u2t+o2JoS8FdOuGLbk2Mb6xY2Lkxcae\nuCYp3LFJtI3tRTW4UakCAwEAAaNZMFcwDgYDVR0PAQH/BAQDAgKkMA8GA1UdEwEB\n/wQFMAMBAf8wHQYDVR0OBBYEFG3mY1MVXImbuVRRXdPzRRKbdqC0MBUGA1UdEQQO\nMAyCCmt1YmVybmV0ZXMwDQYJKoZIhvcNAQELBQADggEBABMExrlbEGCE8zvNekZ7\nDNxQb1086PGC5/ij9OjtsNfNjiEcDWtC2I8+KVXY/WhvZlGEG/dbkajXzXHH+18H\nHaIm+C7bOc2kzrL7z2IAF5jc8ESehxN5IvOzN/yhYnZtH9CTWZoZeQl54HF+c2Se\nxVrjG7zc6UpgkgZWTNfJXpXHOfqE1rptl/r290HijbtUT4O9KUTTU5p3ZWP6shwz\nOlYPPB8sAhnaqV6R8SuH/M7JnwX/k1jXA582gB6hwZwHwx7CUy1eu3AZ+dReYBK7\n7WkitNJsJwpGgMLmYenkRkF35qTxJzzBnQuiHdcySvXVNwVCMlbivyB1Xvxa5MXO\nMDA=\n-----END CERTIFICATE-----\n"
            },
            "kind": "ConfigMap",
            "metadata": {
                "annotations": {
                    "kubernetes.io/description": "Contains a CA bundle that can be used to verify the kube-apiserver when using internal endpoints such as the internal service IP or kubernetes.default.svc. No other usage is guaranteed across distributions of Kubernetes clusters."
                },
                "creationTimestamp": "2023-04-08T13:37:46Z",
                "name": "kube-root-ca.crt",
                "namespace": "default",
                "resourceVersion": "311",
                "uid": "8d926976-9831-4db0-b883-a4a5ece2b998"
            }
        },
        {
            "apiVersion": "v1",
            "data": {
                "nginx.conf": "server {\n    listen 80;\n    server_name  netology.ru www.netology.ru;\n    access_log  /var/log/nginx/domains/netology.ru-access.log  main;\n    error_log   /var/log/nginx/domains/netology.ru-error.log info;\n    location / {\n        include proxy_params;\n        proxy_pass http://10.10.10.10:8080/;\n    }\n}\n"
            },
            "kind": "ConfigMap",
            "metadata": {
                "creationTimestamp": "2023-04-08T13:56:28Z",
                "name": "nginx-config",
                "namespace": "default",
                "resourceVersion": "2895",
                "uid": "f7aa504f-2160-4be6-9555-780151562ad5"
            }
        }
    ],
    "kind": "List",
    "metadata": {
        "resourceVersion": ""
    }
}
/14-clokub-03-config-maps# kubectl get configmap nginx-config -o yaml > nginx-config.yml

/14-clokub-03-config-maps# cat nginx-config.yml
apiVersion: v1
data:
  nginx.conf: |
    server {
        listen 80;
        server_name  netology.ru www.netology.ru;
        access_log  /var/log/nginx/domains/netology.ru-access.log  main;
        error_log   /var/log/nginx/domains/netology.ru-error.log info;
        location / {
            include proxy_params;
            proxy_pass http://10.10.10.10:8080/;
        }
    }
kind: ConfigMap
metadata:
  creationTimestamp: "2023-04-08T13:56:28Z"
  name: nginx-config
  namespace: default
  resourceVersion: "2895"
  uid: f7aa504f-2160-4be6-9555-780151562ad5
  
/14-clokub-03-config-maps# kubectl delete configmap nginx-config
configmap "nginx-config" deleted

/14-clokub-03-config-maps# kubectl get configmaps
NAME               DATA   AGE
domain             1      108s
kube-root-ca.crt   1      20m

/14-clokub-03-config-maps# kubectl apply -f nginx-config.yml
configmap/nginx-config created

/14-clokub-03-config-maps# kubectl get configmaps
NAME               DATA   AGE
domain             1      2m
kube-root-ca.crt   1      20m
nginx-config       1      5s
```
