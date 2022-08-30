# Домашнее задание к занятию "3.7. Компьютерные сети, лекция 2"

1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?

2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?

3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.

4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.

5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.

6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.

7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?



 ---
## Задание для самостоятельной отработки (необязательно к выполнению)

 8*. Установите эмулятор EVE-ng.
 
 Инструкция по установке - https://github.com/svmyasnikov/eve-ng

 Выполните задания на lldp, vlan, bonding в эмуляторе EVE-ng. 
 
 ---
 
 ## Ответ:
 
- **1.** ipconfig
```
Настройка протокола IP для Windows


Адаптер Ethernet Ethernet:

...

Адаптер Ethernet Ethernet 4:

...

Адаптер Ethernet Ethernet 5:

...

Адаптер Ethernet vEthernet (Default Switch):
...
```
Для linux можно использовать `ip a`, `ifconfig`. Для Windows `ipconfig`.
- **2.** Используется протокол LLDP. Пакет можно Установить можно командой `apt install lldpd`, после установки необходимо запустить службу.
```
root@vagrant:/home/vagrant# lldpctl
-------------------------------------------------------------------------------
LLDP neighbors:
-------------------------------------------------------------------------------
Interface:    eth1, via: LLDP, RID: 1, Time: 0 day, 01:36:18
  Chassis:
    ChassisID:    mac 
  Port:
    PortID:       mac 
    TTL:          3601
    PMD autoneg:  supported: yes, enabled: yes
      Adv:          1000Base-T, HD: no, FD: yes
      MAU oper type: unknown
  LLDP-MED:
    Device Type:  Generic Endpoint (Class I)
    Capability:   Capabilities, yes
```
- **3.** Технология VLAN. Пакет vlan, установка - `apt install vlan`. Конфигурация настраивается в /etc/network/interfaces, например для eth0:
```
root@vagrant:/home/vagrant# vim /etc/network/interfaces
auto eth0.100
iface eth0.100 inet static
address 192.168.1.100
netmask 255.255.255.0
vlan-raw-device eth0
```
- **4.** Используется bonding, с помощью утилиты `ifenslave` - `apt install ifenslave`. Конфигурация также настраивается в /etc/network/interfaces:
```
root@vagrant:/home/vagrant# vim /etc/network/interfaces
...
auto bond0
iface bond0 inet static
bond-mode 4
bond-miimon 100
bond-lacp-rate 1
bond-slaves none
address 10.0.0.80
gateway 10.0.0.1
netmask 255.255.255.0
```
Перезагрузить ВМ, состояние хранится в /proc/net/bonding/bond0.
- **5.** Всего 8. /29 подсетей в сети с маской /24 можно построить 32. Минимальное значение адреса 10.10.10.1, максимальное значение адреса 10.10.10.6.
- **6.** Если всё правильно понял можно использовать такую сеть - 100.64.0.0/26.
- **7.** В Windows `arp -a`, в linux `ip neigh`. Очистить в linux `ip neigh flush all`, в windows `netsh interface ip delete arpcache`. Удалить адрес в windows `arp -d x.x.x.x`, в linux `ip neigh del dev enp0s3 x.x.x.x`.
