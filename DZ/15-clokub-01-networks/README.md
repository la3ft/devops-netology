# Домашнее задание к занятию "15.1. Организация сети"

Домашнее задание будет состоять из обязательной части, которую необходимо выполнить на провайдере Яндекс.Облако и дополнительной части в AWS по желанию. Все домашние задания в 15 блоке связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
Все задания требуется выполнить с помощью Terraform, результатом выполненного домашнего задания будет код в репозитории. 

Перед началом работ следует настроить доступ до облачных ресурсов из Terraform используя материалы прошлых лекций и [ДЗ](https://github.com/netology-code/virt-homeworks/tree/master/07-terraform-02-syntax ). А также заранее выбрать регион (в случае AWS) и зону.

---
## Задание 1. Яндекс.Облако (обязательное к выполнению)

1. Создать VPC.
- Создать пустую VPC. Выбрать зону.
2. Публичная подсеть.
- Создать в vpc subnet с названием public, сетью 192.168.10.0/24.
- Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1
- Создать в этой публичной подсети виртуалку с публичным IP и подключиться к ней, убедиться что есть доступ к интернету.
3. Приватная подсеть.
- Создать в vpc subnet с названием private, сетью 192.168.20.0/24.
- Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс
- Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее и убедиться что есть доступ к интернету

Resource terraform для ЯО
- [VPC subnet](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet)
- [Route table](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_route_table)
- [Compute Instance](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance)
---

## Ответ:

### 1. Яндекс.Облако:
Terraform: https://github.com/la3ft/devops-netology/tree/main/DZ/15-clokub-01-networks/terraform/main.tf
1. VPC  
  ```bash
  $ yc vpc network list
  +----------------------+------+
  |          ID          | NAME |
  +----------------------+------+
  | bfe6c213k5qdefe6sad | vpc  |
  +----------------------+------+
  ```
  
2. Public  
```bash
  $ ssh vagrant@158.160.48.207
  Welcome to Ubuntu 22.04.1 LTS (GNU/Linux 5.15.0-58-generic x86_64)
  
   * Documentation:  https://help.ubuntu.com
   * Management:     https://landscape.canonical.com
   * Support:        https://ubuntu.com/advantage
  
    System information as of Sun Jan 29 02:09:14 PM UTC 2023
  
    System load:  0.177734375       Processes:             133
    Usage of /:   80.3% of 4.84GB   Users logged in:       0
    Memory usage: 10%               IPv4 address for eth0: 192.168.10.17
    Swap usage:   0%
  vagrant@fhmpa9sg8ounjlblprnp:~$ ping 1.1.1.1
  PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
  64 bytes from 1.1.1.1: icmp_seq=1 ttl=61 time=5.06 ms
  64 bytes from 1.1.1.1: icmp_seq=2 ttl=61 time=4.53 ms
  64 bytes from 1.1.1.1: icmp_seq=3 ttl=61 time=4.53 ms
  64 bytes from 1.1.1.1: icmp_seq=4 ttl=61 time=4.54 ms
  64 bytes from 1.1.1.1: icmp_seq=5 ttl=61 time=4.43 ms
  ^C
  --- 1.1.1.1 ping statistics ---
  5 packets transmitted, 5 received, 0% packet loss, time 4006ms
  rtt min/avg/max/mdev = 4.431/4.618/5.055/0.221 ms
  ```

3. Private
```bash
  $ yc vpc route-table list
  +----------------------+------+-------------+----------------------+
  |          ID          | NAME | DESCRIPTION |      NETWORK-ID      |
  +----------------------+------+-------------+----------------------+
  | enpocaatrqh7ohqubbvu |      |             | enp7v108k5qedstq6sal |
  +----------------------+------+-------------+----------------------+
  ```

```bash
  vagrant@fhmpa9sg8ounjlblprnp:~$ ssh ubuntu@192.168.20.26
  Welcome to Ubuntu 22.04.1 LTS (GNU/Linux 5.15.0-58-generic x86_64)
  
   * Documentation:  https://help.ubuntu.com
   * Management:     https://landscape.canonical.com
   * Support:        https://ubuntu.com/advantage
  
    System information as of Sun Jan 29 02:09:34 PM UTC 2023
  
    System load:  0.310546875       Processes:             134
    Usage of /:   80.3% of 4.84GB   Users logged in:       0
    Memory usage: 10%               IPv4 address for eth0: 192.168.20.26
    Swap usage:   0%
  ubuntu@fhm5i4cl6uoq43h7fp85:~$ ping 1.1.1.1
  PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
  64 bytes from 1.1.1.1: icmp_seq=1 ttl=59 time=5.42 ms
  64 bytes from 1.1.1.1: icmp_seq=2 ttl=59 time=4.09 ms
  64 bytes from 1.1.1.1: icmp_seq=3 ttl=59 time=4.23 ms
  ^C
  --- 1.1.1.1 ping statistics ---
  3 packets transmitted, 3 received, 0% packet loss, time 2003ms
  rtt min/avg/max/mdev = 4.091/4.581/5.420/0.595 ms
  ubuntu@fhm5i4cl6uoq43h7fp85:~$ ping 192.168.10.254
  PING 192.168.10.254 (192.168.10.254) 56(84) bytes of data.
  64 bytes from 192.168.10.254: icmp_seq=1 ttl=63 time=1.44 ms
  64 bytes from 192.168.10.254: icmp_seq=2 ttl=63 time=0.637 ms
  64 bytes from 192.168.10.254: icmp_seq=3 ttl=63 time=0.666 ms
  64 bytes from 192.168.10.254: icmp_seq=4 ttl=63 time=0.588 ms
  64 bytes from 192.168.10.254: icmp_seq=5 ttl=63 time=0.658 ms
  ^C
  --- 192.168.10.254 ping statistics ---
  5 packets transmitted, 5 received, 0% packet loss, time 4056ms
  rtt min/avg/max/mdev = 0.588/0.796/1.435/0.320 ms
  ```

```bash
  $ yc vpc subnet list
+----------------------+---------+----------------------+----------------------+---------------+-------------------+
|          ID          |  NAME   |      NETWORK ID      |    ROUTE TABLE ID    |     ZONE      |       RANGE       |
+----------------------+---------+----------------------+----------------------+---------------+-------------------+
| e9b8n9udj843hpe05dqe | public  | enp7v108k5qedstq6sal |                      | ru-central1-a | [192.168.10.0/24] |
| e9br3r5k6bq7h9qfa4qo | private | enp7v108k5qedstq6sal | enpocaatrqh7ohqubbvu | ru-central1-a | [192.168.20.0/24] |
+----------------------+---------+----------------------+----------------------+---------------+-------------------+
```

```bash
$ yc compute instance list
+----------------------+------------------+---------------+---------+---------------+----------------+
|          ID          |       NAME       |    ZONE ID    | STATUS  |  EXTERNAL IP  |  INTERNAL IP   |
+----------------------+------------------+---------------+---------+---------------+----------------+
| fhm5i4cl6uoq43h7fp85 | private-instance | ru-central1-a | RUNNING |               | 192.168.20.26  |
| fhm5ujgact4okni6ihg6 | vpc-nat-instance | ru-central1-a | RUNNING | 51.250.3.132  | 192.168.10.254 |
| fhmpa9sg8ounjlblprnp | public-instance  | ru-central1-a | RUNNING | 51.250.14.136 | 192.168.10.17  |
+----------------------+------------------+---------------+---------+---------------+----------------+
```