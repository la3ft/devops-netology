# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"

## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
- Какой из принципов IaaC является основополагающим?

### Ответ:
- Удобство - можно написать код один раз, а не повторять однотипные действия по много раз, также это обеспечивает быстроту и значительно уменьшает трудозатраты. Также обеспечивает стабильность;
- Идемпотентность - при выполнении кода написанного один раз у нас будет получаться один и тот же результат.


## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

### Ответ:
- Ansible прост в читаемости, для него необходимо разворачивать дополнительные компоненты и он способен работать в текущей SSH среде. Также он может быть использован и для настройки ПО и для разворачивания ВМ, что делает его универсальным;
- Наверное всё же более надёжный способ push, так как обновление происходит с одной точки управления, что должно помогать в администрировании и решении возможных проблем.


## Задача 3

Установить на личный компьютер:

- VirtualBox
- Vagrant
- Ansible

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

### Ответ:
- VirtualBox
```
PS C:\Program Files\Oracle\VirtualBox> .\vboxmanage -v
6.1.32r149290
```
- Vagrant
```
vagrant version
Installed Version: 2.2.19
Latest Version: 2.2.19
```
- Ansible
```
root@DESKTOP-xxxxxx:~# ansible --version
ansible [core 2.12.4]
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  ansible collection location = /root/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.8.2 (default, Mar 13 2020, 10:14:16) [GCC 9.3.0]
  jinja version = 2.10.1
  libyaml = True
```


## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
```
docker ps
```

### Ответ:
```
root@vagrant:/home/vagrant# docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```
