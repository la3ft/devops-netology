# Домашнее задание к занятию "14.5 SecurityContext, NetworkPolicies"

## Задача 1: Рассмотрите пример 14.5/example-security-context.yml

Создайте модуль

```
kubectl apply -f 14.5/example-security-context.yml
```

Проверьте установленные настройки внутри контейнера

```
kubectl logs security-context-demo
uid=1000 gid=3000 groups=3000
```

## Ответ:

### 1. Листинг:
```
root@node1:/home/vagrant# kubectl apply -f example-security-context.yml
pod/security-context-demo created
root@node1:/home/vagrant# kubectl get po
NAME                    READY   STATUS             RESTARTS      AGE
security-context-demo   0/1     CrashLoopBackOff   3 (19s ago)   79s
root@node1:/home/vagrant# kubectl logs security-context-demo
uid=1000 gid=3000 groups=3000
```