# Домашнее задание к занятию "3.4. Операционные системы, лекция 2"

1. На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:

    * поместите его в автозагрузку,
    * предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),
    * удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.

1. Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.
1. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`). После успешной установки:
    * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,
    * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:

    ```bash
    config.vm.network "forwarded_port", guest: 19999, host: 19999
    ```

    После успешной перезагрузки в браузере *на своем ПК* (не в виртуальной машине) вы должны суметь зайти на `localhost:19999`. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.

1. Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?
1. Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?
1. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.
1. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?

## Ответ:
- **1.** Выполнялось под root (`sudo su`)
1. Создать пользователя node_exporter - `useradd node_exporter`;
2. Скачать и разархивировать пакет `node_exporter-1.3.1.linux-amd64.tar.gz` по указанной ссылке;
3. Перейти в папку и расположить node_exporter в /usr/local/bin - `cp node_exporter /usr/local/bin`;
4. Создать файл демона и прописать ему настройки `vim /etc/systemd/system/node_exporter.service`:
```
[Unit]
Description=Node Exporter
After=network.target

[Service]
#Внешний файл по аналогии с cron
EnvironmentFile=-/opt/node_exporter/tst.yml
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
```
5. Перезапустить службы, включить службу в автозагрузку (enable):
```
root@vagrant:/home/vagrant# systemctl daemon-reload
root@vagrant:/home/vagrant# systemctl enable --now node_exporter
```
6. Проверить работу демона `systemctl status node_exporter`:
```
root@vagrant:/home/vagrant# systemctl status node_exporter
● node_exporter.service - Node Exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor pr>
     Active: active (running) since Tue 2022-02-22 19:01:24 +05; 1min 40s ago
   Main PID: 668 (node_exporter)
      Tasks: 5 (limit: 2314)
     Memory: 14.1M
     CGroup: /system.slice/node_exporter.service
             └─668 /usr/local/bin/node_exporter
Feb 22 19:01:25 vagrant node_exporter[668]: ts=2022-02-22T14:01:25.260Z caller=nod>
Feb 22 19:01:25 vagrant node_exporter[668]: ts=2022-02-22T14:01:25.260Z caller=nod>
Feb 22 19:01:25 vagrant node_exporter[668]: ts=2022-02-22T14:01:25.260Z caller=nod>
Feb 22 19:01:25 vagrant node_exporter[668]: ts=2022-02-22T14:01:25.260Z caller=nod>
Feb 22 19:01:25 vagrant node_exporter[668]: ts=2022-02-22T14:01:25.260Z caller=nod>
Feb 22 19:01:25 vagrant node_exporter[668]: ts=2022-02-22T14:01:25.260Z caller=nod>
Feb 22 19:01:25 vagrant node_exporter[668]: ts=2022-02-22T14:01:25.260Z caller=nod>
Feb 22 19:01:25 vagrant node_exporter[668]: ts=2022-02-22T14:01:25.260Z caller=nod>
Feb 22 19:01:25 vagrant node_exporter[668]: ts=2022-02-22T14:01:25.260Z caller=nod>
Feb 22 19:01:25 vagrant node_exporter[668]: ts=2022-02-22T14:01:25.260Z caller=tls>
```
- **2.** По найденным параметрам "cpu", "memory", "disk", "network" ():
```
CPU
node_cpu_seconds_total{cpu="0",mode="idle"} 319.68
node_cpu_seconds_total{cpu="0",mode="iowait"} 0.2
process_cpu_seconds_total

Память
node_memory_MemFree_bytes
node_memory_MemTotal_bytes

Диск
node_disk_io_time_seconds_total{device="dm-0"} 7.908
node_disk_io_time_seconds_total{device="sda"} 8.132
node_disk_write_time_seconds_total{device="dm-0"} 1.964
node_disk_write_time_seconds_total{device="sda"} 1.95

Сеть
node_network_speed_bytes{device="eth0"}
node_network_receive_errs_total{device="eth0"}
```
- **3.** Удалось установить и пробросить указанный порт, приложил скрины (dz_3_1.PNG и dz_3_2.PNG)
- **4.** Да, можно грепнуть ключевое слово и увидеть запись о ядре KVM - `dmesg | grep virt`
```
root@vagrant:/home/vagrant# dmesg | grep virt
[    0.002428] CPU MTRRs all blank - virtualized system.
[    0.026488] Booting paravirtualized kernel on KVM
[    0.370112] Performance Events: PMU not available due to virtualization, using software events only.
[    4.006548] systemd[1]: Detected virtualization oracle.
```
- **5.** Судя по выводу `sysctl -n fs.nr_open` - 1048576:
```
root@vagrant:/home/vagrant# sysctl -n fs.nr_open
1048576
```
Это лимит на маскимальное количетсво открытых файловых дескрипторов. Судя по `ulimit --help` лимит кратен 1024, `ulimit -Sn` - показывает текущий лимит, `ulimit -Hn` - показывает максимально доступный лимит.
- **6.** Вызовем на другом терминале `sleep 1h`, в нашем другом терминале сделаем вызов `ps aux | grep sleep`:
```
root@vagrant:/# ps aux | grep sleep
vagrant     2525  0.0  0.0   5476   532 pts/1    S+   21:02   0:00 sleep 1h
```
Если выполняю команду `nsenter -t 2525 -p -m -F` то я перемещаюсь в новый неймспейс, но при этом PID остаётся прежним (даже флаг -F не помогает), разобраться так и не удалось.
- **7.** `:(){ :|:& };:` - это функция которая рекурсивно вызывает саму себя, моя ВМ приходила в норму достаточно долго. Если посмотреть вызов `dmesg | grep rejected` томожно увидеть следующее:
```
vagrant@vagrant:~$ dmesg | grep rejected
[  189.998690] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-5.scope
```
С помощью `ulimit -a` можно посмотреть максимальное количество процессов для пользователя:
```
max user processes              (-u) 7715
```
Изменить это количество можно с помощью `ulimit -u`, например:
```
vagrant@vagrant:~$ ulimit -u 100
vagrant@vagrant:~$ ulimit -u
100
```
