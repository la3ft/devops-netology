# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | Никакое, будет выведена ошибка "TypeError: unsupported operand type(s) for +: 'int' and 'str'"  |
| Как получить для переменной `c` значение 12?  | Задать переменную a как строку - a = '1', либо сразу в c преобразовать в строку - c=str(a)+b  |
| Как получить для переменной `c` значение 3?  | Задать переменную b как целочисленную - b = 2, либо сразу в c преобразовать в число - c=a+int(b)  |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

path = os.getcwd()
bash_command = ["cd /home/vagrant/git/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '/')
        print(path+prepare_result)
```

### Вывод скрипта при запуске при тестировании:
(изменялись README.md и /01-intro-01/netology.md)
```
root@vagrant:/home/vagrant/git/sysadm-homeworks# ./04-script-02.py
/home/vagrant/git/sysadm-homeworks/01-intro-01/netology.md
/home/vagrant/git/sysadm-homeworks/README.md
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os, sys

path = sys.argv[1]
bash_command = ["cd "+path, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(path+prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```
root@vagrant:/home/vagrant/git# ./04-script-03.py /home/vagrant/git/sysadm-homeworks/
/home/vagrant/git/sysadm-homeworks/01-intro-01/netology.md
/home/vagrant/git/sysadm-homeworks/README.md

root@vagrant:/home/vagrant/git# ./04-script-03.py /home/vagrant/git/
fatal: not a git repository (or any of the parent directories): .git
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import socket

a = 1
b = 0
hosts = {'drive.google.com':'0.0.0.0', 'mail.google.com':'0.0.0.0', 'google.com':'0.0.0.0'}

#Вывод текущих значений + запись их в справочник
for host in hosts:
    ip = socket.gethostbyname(host)
    print(host+' '+ip)
    hosts[host] = ip
#Цикл проверки соответствия, в случае изменения будет выведено соотвутствующее сообщение и выход из цикла
while 1==1:
  for host in hosts:
    ip = socket.gethostbyname(host)
    if ip != hosts[host]:
      if a==1 and b !=1:
        print('[ERROR] ' + str(host) +' IP mistmatch: '+hosts[host]+' '+ip)
        exit()
```

### Вывод скрипта при запуске при тестировании:
```
root@vagrant:/home/vagrant/git# ./04-script-04.py
drive.google.com 74.125.131.194
mail.google.com 64.233.164.83
google.com 173.194.73.100
[ERROR] google.com IP mistmatch: 173.194.73.100 173.194.73.113
```
