# Домашнее задание к занятию "3.9. Элементы безопасности информационных систем"

1. Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей.

2. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.

3. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.

4. Проверьте на TLS уязвимости произвольный сайт в интернете (кроме сайтов МВД, ФСБ, МинОбр, НацБанк, РосКосмос, РосАтом, РосНАНО и любых госкомпаний, объектов КИИ, ВПК ... и тому подобное).

5. Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.
 
6. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.

7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.

 ---
## Задание для самостоятельной отработки (необязательно к выполнению)

8*. Просканируйте хост scanme.nmap.org. Какие сервисы запущены?

9*. Установите и настройте фаервол ufw на web-сервер из задания 3. Откройте доступ снаружи только к портам 22,80,443


 ---

## Ответ:
- **1.** Готово:

![Alt text](https://u.netology.ngcdn.ru/backend/uploads/lms/tasks/homework_solutions/hashed_file/0/1528490/DZ_3_9-1.PNG)

- **2.** Готово:

![Alt text](https://u.netology.ngcdn.ru/backend/uploads/lms/tasks/homework_solutions/hashed_file/1/1528491/DZ_3_9-2.PNG)

- **3.** Установить apache2 с помощью `apt install apache2`, включить mod_ssl:
```
root@vagrant:/etc/apache2# a2enmod ssl
Considering dependency setenvif for ssl:
Module setenvif already enabled
Considering dependency mime for ssl:
Module mime already enabled
Considering dependency socache_shmcb for ssl:
Enabling module socache_shmcb.
Enabling module ssl.
See /usr/share/doc/apache2/README.Debian.gz on how to configure SSL and create self-signed certificates.
To activate the new configuration, you need to run:
  systemctl restart apache2
root@vagrant:/etc/apache2# systemctl restart apache2
```
Создать пару ключ сертификат - `openssl req -x509 -nodes -days 365 -newkey rsa:2048 \-keyout /etc/ssl/private/apache-selfsigned.key \-out /etc/ssl/certs/apache-selfsigned.crt`. После создания пары их можно использовать в нашем вебсервере, я использовал ключ и сертификат в самом apache2:

![Alt text](https://u.netology.ngcdn.ru/backend/uploads/lms/tasks/homework_solutions/hashed_file/2/1528492/DZ_3_9-3.PNG)

- **4.** Проверка github.com:
```
root@vagrant:/home/vagrant/testssl.sh# ./testssl.sh -e --fast --parallel https://github.com/

###########################################################
    testssl.sh       3.1dev from https://testssl.sh/dev/
    (90c6134 2022-03-16 15:25:06 -- )

      This program is free software. Distribution and
             modification under GPLv2 permitted.
      USAGE w/o ANY WARRANTY. USE IT AT YOUR OWN RISK!

       Please file bugs @ https://testssl.sh/bugs/

###########################################################

 Using "OpenSSL 1.0.2-chacha (1.0.2k-dev)" [~183 ciphers]
 on vagrant:./bin/openssl.Linux.x86_64
 (built: "Jan 18 17:12:17 2019", platform: "linux-x86_64")


 Start 2022-03-20 11:57:26        -->> 140.82.121.4:443 (github.com) <<--

 rDNS (140.82.121.4):    lb-140-82-121-4-fra.github.com.
 Service detected:       HTTP



 Testing all 183 locally available ciphers against the server, ordered by encryption strength


Hexcode  Cipher Suite Name (OpenSSL)       KeyExch.   Encryption  Bits     Cipher Suite Name (IANA/RFC)
-----------------------------------------------------------------------------------------------------------------------------
 xc030   ECDHE-RSA-AES256-GCM-SHA384       ECDH 256   AESGCM      256      TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
 xc02c   ECDHE-ECDSA-AES256-GCM-SHA384     ECDH 256   AESGCM      256      TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
 xc028   ECDHE-RSA-AES256-SHA384           ECDH 256   AES         256      TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384
 xc024   ECDHE-ECDSA-AES256-SHA384         ECDH 256   AES         256      TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384
 xc014   ECDHE-RSA-AES256-SHA              ECDH 256   AES         256      TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA
 xc00a   ECDHE-ECDSA-AES256-SHA            ECDH 256   AES         256      TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA
 x9d     AES256-GCM-SHA384                 RSA        AESGCM      256      TLS_RSA_WITH_AES_256_GCM_SHA384
 x3d     AES256-SHA256                     RSA        AES         256      TLS_RSA_WITH_AES_256_CBC_SHA256
 x35     AES256-SHA                        RSA        AES         256      TLS_RSA_WITH_AES_256_CBC_SHA
 xc02f   ECDHE-RSA-AES128-GCM-SHA256       ECDH 256   AESGCM      128      TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
 xc02b   ECDHE-ECDSA-AES128-GCM-SHA256     ECDH 256   AESGCM      128      TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
 xc027   ECDHE-RSA-AES128-SHA256           ECDH 256   AES         128      TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256
 xc023   ECDHE-ECDSA-AES128-SHA256         ECDH 256   AES         128      TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256
 x9c     AES128-GCM-SHA256                 RSA        AESGCM      128      TLS_RSA_WITH_AES_128_GCM_SHA256
 x3c     AES128-SHA256                     RSA        AES         128      TLS_RSA_WITH_AES_128_CBC_SHA256
 x2f     AES128-SHA                        RSA        AES         128      TLS_RSA_WITH_AES_128_CBC_SHA


 Done 2022-03-20 11:57:32 [   7s] -->> 140.82.121.4:443 (github.com) <<--
```
- **5.** Удалось выполнить подключение к своей другой ВМ:
```
root@vagrant:/home/vagrant# ssh-copy-id -i /home/vagrant/key1.pub laft@192.16
8.3.55
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/vagrant/key1.pub"
The authenticity of host '192.168.3.55 (192.168.3.55)' can't be established.
ECDSA key fingerprint is SHA256:hJBJVXggQhDq5vr+V9251h5LdKykMmw4tfRBMhxch5g.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
laft@192.168.3.55's password:

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'laft@192.168.3.55'"
and check to make sure that only the key(s) you wanted were added.

root@vagrant:/home/vagrant# ssh laft@192.168.3.55
laft@192.168.3.55's password:
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.13.0-28-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

82 updates can be applied immediately.
To see these additional updates run: apt list --upgradable

Your Hardware Enablement Stack (HWE) is supported until April 2025.
Last login: Sat Feb  5 18:30:18 2022 from fe80::e869:d7bb:f8cf:3a7b%enp0s3
laft@laft-VirtualBox:~$
```
- **6.** Создать файл конфигурации `vagrant@vagrant:~/.ssh$ vim config`:
```
Host laft-vm
HostName 192.168.3.55
User laft
Port 22
```
После этого можно подключаться:
```
vagrant@vagrant:~/.ssh$ ssh laft-vm
laft@192.168.3.55's password:
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.13.0-28-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

82 updates can be applied immediately.
To see these additional updates run: apt list --upgradable

Your Hardware Enablement Stack (HWE) is supported until April 2025.
Last login: Sun Mar 20 18:11:16 2022 from 192.168.3.58
laft@laft-VirtualBox:~$
```
- **7.** Выполнил запись с помощью команды `root@vagrant:/home/vagrant# tcpdump -i eth1 -c 100 -w 0001.pcap`. Скрин:

![Alt text](https://u.netology.ngcdn.ru/backend/uploads/lms/tasks/homework_solutions/hashed_file/3/1528493/DZ_3_9-4.PNG)
