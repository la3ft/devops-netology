# Домашнее задание к занятию "12.2 Команды для работы с Kubernetes"
Кластер — это сложная система, с которой крайне редко работает один человек. Квалифицированный devops умеет наладить работу всей команды, занимающейся каким-либо сервисом.
После знакомства с кластером вас попросили выдать доступ нескольким разработчикам. Помимо этого требуется служебный аккаунт для просмотра логов.

## Задание 1: Запуск пода из образа в деплойменте
Для начала следует разобраться с прямым запуском приложений из консоли. Такой подход поможет быстро развернуть инструменты отладки в кластере. Требуется запустить деплоймент на основе образа из hello world уже через deployment. Сразу стоит запустить 2 копии приложения (replicas=2). 

Требования:
 * пример из hello world запущен в качестве deployment
 * количество реплик в deployment установлено в 2
 * наличие deployment можно проверить командой kubectl get deployment
 * наличие подов можно проверить командой kubectl get pods


## Задание 2: Просмотр логов для разработки
Разработчикам крайне важно получать обратную связь от штатно работающего приложения и, еще важнее, об ошибках в его работе. 
Требуется создать пользователя и выдать ему доступ на чтение конфигурации и логов подов в app-namespace.

Требования: 
 * создан новый токен доступа для пользователя
 * пользователь прописан в локальный конфиг (~/.kube/config, блок users)
 * пользователь может просматривать логи подов и их конфигурацию (kubectl logs pod <pod_id>, kubectl describe pod <pod_id>)


## Задание 3: Изменение количества реплик 
Поработав с приложением, вы получили запрос на увеличение количества реплик приложения для нагрузки. Необходимо изменить запущенный deployment, увеличив количество реплик до 5. Посмотрите статус запущенных подов после увеличения реплик. 

Требования:
 * в deployment из задания 1 изменено количество реплик на 5
 * проверить что все поды перешли в статус running (kubectl get pods)

## Ответы:
### 1. Запуск в deployment.
```
root@vagrant:/home/vagrant# kubectl create deployment hello-deployment --image=k8s.gcr.io/echoserver:1.4 --replicas=2
deployment.apps/hello-deployment created
root@vagrant:/home/vagrant# kubectl get deployment
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
hello-deployment   2/2     2            2           108s
root@vagrant:/home/vagrant# kubectl get pods
NAME                               READY   STATUS    RESTARTS   AGE
hello-deployment-d6bbf86fc-phq5d   1/1     Running   0          2m3s
hello-deployment-d6bbf86fc-wlj9s   1/1     Running   0          2m3s
```

### 2. Добавлены пользователи.
Создать сертификаты и ключи:
```
root@vagrant:/home/vagrant# openssl genrsa -out developer.key 2048
Generating RSA private key, 2048 bit long modulus (2 primes)
...............+++++
...................................+++++
e is 65537 (0x010001)
root@vagrant:/home/vagrant# openssl req -new -key developer.key -out developer.csr -subj "/CN=developer/O=readers"
root@vagrant:/home/vagrant# export BASE64_CSR=$(cat ./developer.csr | base64 | tr -d '\n')
```
Создать ресурс для CSR запроса:
```
root@vagrant:/home/vagrant# vim developer.yaml
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
 name: developer
spec:
 request: ${BASE64_CSR}
 signerName: kubernetes.io/kube-apiserver-client
 expirationSeconds: 8640000  # 100 days
 usages:
   - digital signature
   - key encipherment
   - client auth
```
Применим созданный ресурс для куба:
```
root@vagrant:/home/vagrant# cat developer.yaml | envsubst | kubectl apply -f -
certificatesigningrequest.certificates.k8s.io/developer created
```

Проверим вывод ожидаемых CSR запросов:
```
root@vagrant:/home/vagrant# kubectl get csr
NAME        AGE   SIGNERNAME                            REQUESTOR       REQUESTEDDURATION   CONDITION
developer   42s   kubernetes.io/kube-apiserver-client   minikube-user   100d                Pending
```

Подтверждаем созданный запрос:
```
root@vagrant:/home/vagrant# kubectl certificate approve developer
certificatesigningrequest.certificates.k8s.io/developer approved
```

Извлечь подписанный сертификат:
```
root@vagrant:/home/vagrant# kubectl get csr developer -o jsonpath='{.status.certificate}' | base64 --decode > developer.crt
```

Создать пользователя в конфигурации куба указав пути до ключа и сертификата:
```
root@vagrant:/home/vagrant# kubectl config set-credentials developer --client-certificate=/home/vagrant/developer.crt --client-key=/home/vagrant/developer.key
```

Создадим контекст для работы:
```
root@vagrant:/home/vagrant# kubectl config set-context developer-context --cluster=minikube --user=developer
Context "developer-context" created.
root@vagrant:/home/vagrant# kubectl config get-contexts
CURRENT   NAME                CLUSTER    AUTHINFO    NAMESPACE
*         developer-context   minikube   developer
          minikube            minikube   minikube    default
```

Создадим роль и кластер роль(RBAC):
```
root@vagrant:/home/vagrant# vim developer-role.yaml
```
```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: developer-role
rules:
  - apiGroups: [ "" ]
    resources:
      - pods
      - pods/log
    verbs:
      - get
      - list
```
```
root@vagrant:/home/vagrant# vim developer-cluster.yaml
```
```
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: developer-cluster
  namespace: default
subjects:
- kind: User
  name: developer
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: developer-role
  apiGroup: rbac.authorization.k8s.io
```

Применим их:
```
root@vagrant:/home/vagrant# kubectl apply -f developer-role.yaml
clusterrole.rbac.authorization.k8s.io/developer-role created
root@vagrant:/home/vagrant# kubectl apply -f developer-cluster.yaml
rolebinding.rbac.authorization.k8s.io/developer-cluster created
```

Проверим работу и доступ:
```
root@vagrant:/home/vagrant# kubectl config use-context developer-context
Switched to context "developer-context".
root@vagrant:/home/vagrant# kubectl get pods
NAME                               READY   STATUS    RESTARTS      AGE
hello-deployment-94b846554-k9mg2   1/1     Running   3 (51m ago)   13d
hello-deployment-94b846554-ktfjl   1/1     Running   3 (51m ago)   13d
root@vagrant:/home/vagrant# kubectl delete pod hello-deployment-94b846554-k9mg2
Error from server (Forbidden): pods "hello-deployment-94b846554-k9mg2" is forbidden: User "developer" cannot delete resource "pods" in API group "" in the namespace "default"
root@vagrant:/home/vagrant# kubectl logs hello-deployment-94b846554-k9mg2
```

### 3. Изменено количество реплик.
Создадим файл hello-deployment.yaml, часть содержимого можно подсмотреть в уже созданном деплойменте - `kubectl edit deployment hello-deployment`. Отредактируем и укажем значение `replicas: 5` в разделе spec. Применим изменения с помощью команды `kubectl apply -f hello-deployment.yaml`.
```
root@vagrant:/home/vagrant# kubectl apply -f /home/vagrant/hello-deployment.yaml
deployment.apps/hello-deployment configured
```
Просмотрим результат:
```
root@vagrant:/home/vagrant# kubectl get pods
NAME                               READY   STATUS    RESTARTS   AGE
hello-deployment-94b846554-czxrm   1/1     Running   0          2m24s
hello-deployment-94b846554-h5vkw   1/1     Running   0          2m28s
hello-deployment-94b846554-k9mg2   1/1     Running   0          2m28s
hello-deployment-94b846554-ktfjl   1/1     Running   0          2m28s
hello-deployment-94b846554-l5gxk   1/1     Running   0          2m24s
```
Также можно изменить количество с помощью команды `kubectl scale --replicas=5 deployment/hello-deployment -n default`.
