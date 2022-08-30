# Домашнее задание к занятию "3.6. Компьютерные сети, лекция 1"

1. Работа c HTTP через телнет.
- Подключитесь утилитой телнет к сайту stackoverflow.com
`telnet stackoverflow.com 80`
- отправьте HTTP запрос
```bash
GET /questions HTTP/1.0
HOST: stackoverflow.com
[press enter]
[press enter]
```
- В ответе укажите полученный HTTP код, что он означает?
2. Повторите задание 1 в браузере, используя консоль разработчика F12.
- откройте вкладку `Network`
- отправьте запрос http://stackoverflow.com
- найдите первый ответ HTTP сервера, откройте вкладку `Headers`
- укажите в ответе полученный HTTP код.
- проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?
- приложите скриншот консоли браузера в ответ.
3. Какой IP адрес у вас в интернете?
4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой `whois`
5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой `traceroute`
6. Повторите задание 5 в утилите `mtr`. На каком участке наибольшая задержка - delay?
7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой `dig`
8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой `dig`

В качестве ответов на вопросы можно приложите лог выполнения команд в консоли или скриншот полученных результатов.

## Ответ:

- **1.** Выдаёт код 301, это означает что на вебсервере настроено правило на перенаправление на другую страницу, в нашем случае location: https://stackoverflow.com/questions
```
vagrant@vagrant:~$ telnet stackoverflow.com 80
Trying 151.101.1.69...
Connected to stackoverflow.com.
Escape character is '^]'.
GET /questions HTTP/1.0
HOST: stackoverflow.com

HTTP/1.1 301 Moved Permanently
cache-control: no-cache, no-store, must-revalidate
location: https://stackoverflow.com/questions
x-request-guid: a1aa3d27-50e6-42c9-b004-bd8840f0d074
feature-policy: microphone 'none'; speaker 'none'
content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
Accept-Ranges: bytes
Date: Fri, 04 Mar 2022 12:41:30 GMT
Via: 1.1 varnish
Connection: close
X-Served-By: cache-hel1410033-HEL
X-Cache: MISS
X-Cache-Hits: 0
X-Timer: S1646397691.873302,VS0,VE109
Vary: Fastly-SSL
X-DNS-Prefetch-Control: off
Set-Cookie: prov=3fd012d6-8a8b-a9c3-d749-e88896d5a7c3; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly

Connection closed by foreign host.
```
- **2.** Возвращается код 307, что тоже соответствует правилу перенаправления. Самый долгий ответ с `picture?type=large` - 120 ms, приложил скриншот (DZ_3_6-1.PNG).
- **3.** Адрес - 178.214.XXX.XXX, обнаружен с помощью dig - `dig +short myip.opendns.com @resolver1.opendns.com`.
- **4.** whois 178.214.XXX.XXX:
```
...
descr:          JSC "Ufanet", Ufa, Russia
origin:         AS24955
...
```
- **5.** Из-за NAT использованного в виртуалке можно увидеть только это:
```
root@vagrant:/home/vagrant# traceroute -An 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  10.0.2.2 [*]  0.195 ms  0.151 ms  0.532 ms
 2  10.0.2.2 [*]  2.141 ms  2.111 ms  2.027 ms
```
При прогоне через mtr определяет только одну AS - `AS15169`:
```
vagrant (10.0.2.15)                                       2022-03-04T14:34:16+0000
Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                          Packets               Pings
 Host                                   Loss%   Snt   Last   Avg  Best  Wrst StDev
 1. AS???    10.0.2.2                    0.0%    66    1.2   0.2   0.2   1.2   0.1
 2. AS???    192.168.3.1                 0.0%    66    0.8   0.8   0.7   1.1   0.1
 3. AS???    100.103.0.1                 1.5%    66    2.2   2.5   1.2  29.4   3.8
 4. AS???    10.2.3.17                   0.0%    66    2.1   2.1   1.4  30.1   3.5
 5. AS???    10.1.84.49                  0.0%    66    2.1   5.7   1.8  73.0  12.6
 6. AS???    10.1.67.14                  0.0%    66    1.4   1.4   1.2   1.7   0.1
 7. AS???    10.1.67.65                  0.0%    66    1.6   1.8   1.5   4.9   0.5
 8. AS???    10.1.190.62                 0.0%    66    1.7   3.9   1.5  38.7   6.0
 9. AS???    10.3.2.3                    1.5%    66   28.0  28.6  27.9  44.9   2.2
10. AS15169  72.14.220.188               0.0%    66   23.6  23.9  23.5  25.6   0.3
11. AS15169  142.251.68.223              1.5%    66   23.5  23.6  23.4  25.3   0.3
12. AS15169  108.170.250.99              0.0%    66   24.1  24.2  23.8  25.7   0.4
13. AS15169  142.251.49.24              53.0%    66   35.8  35.9  35.6  36.9   0.3
14. AS15169  209.85.254.20               0.0%    66   39.2  39.1  38.3  48.3   1.4
15. AS15169  216.239.42.21               0.0%    66   38.4  39.0  38.3  43.3   0.8
16. (waiting for reply)
17. (waiting for reply)
18. (waiting for reply)
19. (waiting for reply)
20. (waiting for reply)
21. (waiting for reply)
22. (waiting for reply)
23. (waiting for reply)
24. (waiting for reply)
25. AS15169  8.8.8.8                    10.8%    65   35.9  37.1  34.9  38.8   1.0
```
- **6.** Наибольшая процент на этом участке `AS15169  142.251.49.24`
- **7.** A записи и серверы `dig dns.google`:
```
...
;; ANSWER SECTION:
dns.google.             859     IN      A       8.8.8.8
dns.google.             859     IN      A       8.8.4.4
...
```
- **8.** `dig -x 8.8.8.8`:
```
...
;; ANSWER SECTION:
8.8.8.8.in-addr.arpa.   79351   IN      PTR     dns.google.
...
```
`dig -x 8.8.4.4`: 
```
...
;; ANSWER SECTION:
4.4.8.8.in-addr.arpa.   85837   IN      PTR     dns.google.
...
```
