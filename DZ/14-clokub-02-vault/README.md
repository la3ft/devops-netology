# Домашнее задание к занятию "14.2 Синхронизация секретов с внешними сервисами. Vault"

## Задача 1: Работа с модулем Vault

Запустить модуль Vault конфигураций через утилиту kubectl в установленном minikube

```
kubectl apply -f vault-pod.yml
```

Получить значение внутреннего IP пода

```
kubectl get pod 14.2-netology-vault -o json | jq -c '.status.podIPs'
```

Примечание: jq - утилита для работы с JSON в командной строке

Запустить второй модуль для использования в качестве клиента

```
kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
```

Установить дополнительные пакеты

```
dnf -y install pip
pip install hvac
```

Запустить интепретатор Python и выполнить следующий код, предварительно
поменяв IP и токен

```
import hvac
client = hvac.Client(
    url='http://10.10.133.71:8200',
    token='aiphohTaa0eeHei'
)
client.is_authenticated()
# Пишем секрет
client.secrets.kv.v2.create_or_update_secret(
    path='hvac',
    secret=dict(netology='Big secret!!!'),
)
# Читаем секрет
client.secrets.kv.v2.read_secret_version(
    path='hvac',
)
```

## Ответ:

### 1. Листинг выполнения:

`kubectl apply -f vault-pod.yml`:
```
root@node1:/home/vagrant# kubectl apply -f vault-pod.yml
pod/14.2-netology-vault created
root@node1:/home/vagrant# kubectl get po
NAME                  READY   STATUS    RESTARTS   AGE
14.2-netology-vault   1/1     Running   0          11m
```

`kubectl get pod 14.2-netology-vault -o json | jq -c '.status.podIPs'`
```
root@node1:/home/vagrant# kubectl get pod 14.2-netology-vault -o json | jq -c '.status.podIPs'
[{"ip":"10.233.71.2"}]
```

`kubectl run -i --tty fedora --image=fedora --restart=Never -- sh` + установка pip и hvac:
```
root@node1:/home/vagrant# kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
If you don't see a command prompt, try pressing enter.
sh-5.2# dnf -y install pip
sh-5.2# pip install hvac
```
  
Выполним код:
```
sh-5.2# python3
Python 3.11.2 (main, Feb  8 2023, 00:00:00) [GCC 12.2.1 20221121 (Red Hat 12.2.1-4)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import hvac
>>> client = hvac.Client(
... url='http://10.233.71.2:8200',
... token='aiphohTaa0eeHei'
... )
>>> client.is_authenticated()
True
>>> client.secrets.kv.v2.create_or_update_secret(
... path='hvac',
... secret=dict(netology='Big secret!!!'),
... )
{'request_id': '159d11a3-56c4-30c4-7323-45e633017aa6', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'created_time': '2023-03-29T13:07:08.793673756Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 2}, 'wrap_info': None, 'warnings': None, 'auth': None}
>>> client.secrets.kv.v2.read_secret_version(
... path='hvac',
... )
{'request_id': '02c0aaff-4e0c-60d1-7a3c-734c73528883', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'data': {'netology': 'Big secret!!!'}, 'metadata': {'created_time': '2023-03-29T13:07:08.793673756Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 2}}, 'wrap_info': None, 'warnings': None, 'auth': None}
```
  
*Примечание: https://gitlab.com/k11s-os/k8s-lessons/-/tree/main/Vault*
