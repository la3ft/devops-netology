# Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"

1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
```
telnet route-views.routeviews.org
Username: rviews
show ip route x.x.x.x/32
show bgp x.x.x.x/32
```
2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.

3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.

4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?

5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали. 

 ---
## Задание для самостоятельной отработки (необязательно к выполнению)

6*. Установите Nginx, настройте в режиме балансировщика TCP или UDP.

7*. Установите bird2, настройте динамический протокол маршрутизации RIP.

8*. Установите Netbox, создайте несколько IP префиксов, используя curl проверьте работу API.

## Ответ:

- **1.** Приложил скриншоты DZ_3_8-1.PNG и DZ_3_8-2.PNG
- **2.** Создание интерфейса, его поднятие, добавление маршрутов и отображение конечной маршрутизации:
```
root@vagrant:/home/vagrant# ip link add dummy0 type dummy
root@vagrant:/home/vagrant# ifconfig -a | grep dummy
dummy0: flags=130<BROADCAST,NOARP>  mtu 1500
root@vagrant:/home/vagrant# ip link set dev dummy0 up
root@vagrant:/home/vagrant# ip route add 172.16.10.0/24 dev dummy0 metric 100
root@vagrant:/home/vagrant# ip route add 172.16.15.0/24 dev dummy0 metric 100
root@vagrant:/home/vagrant# route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         berdb2.nix.tele 0.0.0.0         UG    100    0        0 eth0
default         _gateway        0.0.0.0         UG    100    0        0 eth1
10.0.2.0        0.0.0.0         255.255.255.0   U     0      0        0 eth0
berdb2.nix.tele 0.0.0.0         255.255.255.255 UH    100    0        0 eth0
172.16.10.0     0.0.0.0         255.255.255.0   U     100    0        0 dummy0
172.16.15.0     0.0.0.0         255.255.255.0   U     100    0        0 dummy0
192.168.3.0     0.0.0.0         255.255.255.0   U     0      0        0 eth1
192.168.3.0     0.0.0.0         255.255.255.0   U     100    0        0 eth1
_gateway        0.0.0.0         255.255.255.255 UH    100    0        0 eth1
```
- **3.** Просмотр портов с помощью `netstat`
```
root@vagrant:/home/vagrant# netstat -ntlp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      641/systemd-resolve
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      767/sshd: /usr/sbin
tcp6       0      0 :::22                   :::*                    LISTEN      767/sshd: /usr/sbin
```
53 порт указанный для петли используется для DNS-сервера, порт 22 используется для подключения по SSH, адрес вида 0.0.0.0:* говорит о том, что подключение доступно с любого ip, tcp6 аналогично для ipv6. 
- **4.** Также используем `netstat`
```
root@vagrant:/home/vagrant# netstat -ulpn
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
udp        0      0 127.0.0.53:53           0.0.0.0:*                           641/systemd-resolve
udp        0      0 192.168.3.58:68         0.0.0.0:*                           639/systemd-network
udp        0      0 10.0.2.15:68            0.0.0.0:*                           639/systemd-network
```
аналогично как и в прошлом задании, 68 порт отвечает за DHCP.
- **5.** Набрасал простую сеть в drawio (файл DZ_3_8-3.drawio)
