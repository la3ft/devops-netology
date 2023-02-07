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
