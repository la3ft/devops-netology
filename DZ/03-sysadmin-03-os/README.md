# Домашнее задание к занятию "3.3. Операционные системы, лекция 1"

1. Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`. Обратите внимание, что `strace` выдаёт результат своей работы в поток stderr, а не в stdout.
1. Попробуйте использовать команду `file` на объекты разных типов на файловой системе. Например:
    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-64
    ```
    Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.
1. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).
1. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?
1. В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
    На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).
1. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.
1. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
    Есть ли смысл использовать в bash `&&`, если применить `set -e`?
1. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?
1. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).

## Ответ:
- **1.** Обращение к `cd` происходит на 99 строке:
```
chdir("/tmp")                           = 0
```
- **2.** Судя по `strace` она находится в `/usr/share/misc/magic.mgc`:
```
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
```
- **3.** В такой файл можно записать вывод пустоты через `echo`, например(увидеть такие файлы можно с помощью команды `ll`, либо найти с помощью `lsof`):
```
vagrant@vagrant:/tmp$ echo '' > .123.txt.swp
```
Запись лога продолжится, но при этом уже с нуля, что позволит освободить место на диске.
- **4.** Зомби-процесс не расходует ресурсов системы, так как он завершён, но при этом его запись остаётся. Такой процесс удаляется если его родительский процесс передал функцию wait().
- **5.** Вывод `opensnoop-bpfcc`:
```
root@vagrant:/tmp# opensnoop-bpfcc
PID    COMM               FD ERR PATH
642    irqbalance          6   0 /proc/interrupts
642    irqbalance          6   0 /proc/stat
642    irqbalance          6   0 /proc/irq/20/smp_affinity
642    irqbalance          6   0 /proc/irq/0/smp_affinity
642    irqbalance          6   0 /proc/irq/1/smp_affinity
642    irqbalance          6   0 /proc/irq/8/smp_affinity
642    irqbalance          6   0 /proc/irq/12/smp_affinity
642    irqbalance          6   0 /proc/irq/14/smp_affinity
642    irqbalance          6   0 /proc/irq/15/smp_affinity
```
- **6.** Используется `uname()`:
```
uname({sysname="Linux", nodename="vagrant", ...}) = 0
```
Выдержка из `man 2`:
```
Part of the utsname information is  also  accessible  via  /proc/sys/ker‐
       nel/{ostype, hostname, osrelease, version, domainname}.
```
- **7.** Команда `test -d /tmp/some_dir; echo Hi` выполнится в любом случае с выводом Hi, так как `;` - всего лишь разделитель (аналогично `|`). Команда же `test -d /tmp/some_dir && echo Hi` выполняется без вывода Hi, так как `&&` - оператор условия и\или (аналогинчо `||`), и первая наша команда `test -d /tmp/some_dir` не возвращает успешный вывод, так как директории /tmp/some_dir нет и команда echo Hi соответственно не выполняется.
Команда `set -e` завершает сессию после вывода 1 или 2, использовать `<команда1> && set -e` не имеет смысла, так как если у первой команды вывод 1, то и `set -e` не будет выполнена.
- **8.** Судя по `set --help`:
```
errexit      same as -e
nounset      same as -u
xtrace       same as -x
pipefail     the return value of a pipeline is the status of
                           the last command to exit with a non-zero status,
                           or zero if no command exited with a non-zero status
```
Что в переводе с `set -euxo pipefail` по-русски будет означать следующее - выводить подробную информацию о последовательности выполнения команды построчно и в случае неудачного выполнения (вывод не равен 0) - завершать сеанс.
- **9.** Вывод `ps -o stat`:
```
vagrant@vagrant:~$ ps -o stat
STAT
Ss
R+
```
В man даётся описание таким процессам:
```
S    interruptible sleep (waiting for an event to complete)
R    running or runnable (on run queue)
...
s    is a session leader
+    is in the foreground process group
```
Ss - в данной сессии большинство процессов ожидают выполнения

R+ - запускаемые процессы или готовые к запуску.
