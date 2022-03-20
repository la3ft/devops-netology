# ДЗ
Если в файле /terraform/.gitignore будет прописано "*.tfvars" - файлы с расширением tfvars не будут попадать в репозиторий.

# ДЗ 2.4. Инструменты Git

- **1.** `git show aefea`

commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545

Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>

Date:   Thu Jun 18 10:29:58 2020 -0400

    Update CHANGELOG.md

- **2.** `git show 85024d3`

commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)

- **3.** `git show --pretty=raw b8d720`

commit b8d720f8340221f2146e4e4870bf2ee0bc48f2d5

tree cec002aab630c8bc701cb85bc94e55e751cd2d8f

**parent 56cd7859e05c36c06b56d013b55a252d0bb7e158**

**parent 9ea88f22fc6269854151c571162c5bcf958bee2b**

...

- **4.** `git log --oneline v0.12.23..v0.12.24`

33ff1c03b (tag: v0.12.24) v0.12.24

b14b74c49 [Website] vmc provider links

3f235065b Update CHANGELOG.md

6ae64e247 registry: Fix panic when server is unreachable

5c619ca1b website: Remove links to the getting started guide's old location

06275647e Update CHANGELOG.md

d5f9411f5 command: Fix bug when using terraform login on Windows

4b6d06cc5 Update CHANGELOG.md

dd01a3507 Update CHANGELOG.md

225466bc3 Cleanup after v0.12.23 release

- **5.** `git log -L:'func providerSource':provider_source.go`

commit 5af1e6234ab6da412fb8637393c5a17a1b293663

+func providerSource(configs []*cliconfig.ProviderInstallation, services *disco.Disco) (getproviders.Source, tfdiags.Diagnostics)

- **6.** `git log -L:globalPluginDirs:plugins.go`

commit 78b12205587fe839f10d946ea3fdc06719decb05

commit 52dbf94834cb970b510f2fba853a5b49ad9b1a46

commit 41ab0aef7a0fe030e84018973a64135b11abcd70

commit 66ebff90cdfaa6938f26f908c7ebad8d547fea17

commit 8364383c359a6b738a436d1b7745ccdce178df47

- **7.** `git log -SsynchronizedWriters`

commit 5ac311e2a91e381e2f52234668b49ba670aa0fe5

author Martin Atkins <mart@degeneration.co.uk> 1493853941 -0700

# ДЗ 3.1. Работа в терминале, лекция 1

- **5.** По умолчанию Vagrant выделает 1024 Мб оперативной памяти и 2 потока процессора.

- **6.** Для добавления оперативной памяти и потоков в виртуальную машину через Vagrant необходимо добавить следующие строки в Vagrantfile:
```
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048 # Размер оперативной памяти
    vb.cpus = 2 # Количество потоков
  end
```
- **8.** Максимальная длина журнала history задаётся переменной max_input_history, описание есть в `man history` по 325 строке.
Включение директивы ignoreboth в HISTCONTROL означает, что повторающиеся значения вводимых команд не будут отображаться в записях history.

- **9.** Скобки {} применимы при использовании массивов, описание lists содержатся на строке 257.

- **10.** Создать 100000 файлов можно при помощи команды `touch {1..100000}.log`. Аналогичным образом создать 300000 не получится из-за ошибки -bash: /usr/bin/touch: Argument list too long, данный параметр задан значением ARG_MAX (чтобы посмотреть - `getconf ARG_MAX`).

- **11.** Не совсем понятен вопрос про `[[ -d /tmp ]]`. Сами выражения вида [[]] судя по `man bash` - возвращают либо 0, либо 1 в зависимости от истинности условия.

- **12.** Для задания пути переменной необходимо выполнить следующие команды(также приложил скриншоты 12-1.png и 12-2.png) :
```
vagrant@vagrant:~$ mkdir /tmp/new_path_directory/
vagrant@vagrant:~$ cp /bin/bash /tmp/new_path_directory/ # копируем исполняемый файл
vagrant@vagrant:~$ sudo vim /etc/environment # правим пути переменных, вставляя нашу новую директору перед /usr/bin
```
- **13.** Команда `batch` выполняется когда средняя нагрузка системы меньше 1.5 (load average в команде `top`), время выполнения для `batch` не задаётся. Для команды же `at` задаётся точное время выполнения, load average не учитывается.


# ДЗ 3.2. Работа в терминале, лекция 2

- **1.** `cd` это команда, встроенная в shell, посмотреть это можно с помощью команды type:
```
vagrant@vagrant:~$ type cd
cd is a shell builtin
```
Команда `cd` всегда выполняется с exit code 0 в случае успеха, то есть при удачной смене директории, если же к примеру пытаться перейти в несуществующую директорию то команда вернёт ошибку.
- **2.** Чтобы посмотреть количество строк с помощью `grep` можно воспользоваться параметром `-c`. Например `grep "1" 123.txt -c`.
- **3.** Под PID 1 скрывается основной init процесс системы - systemd, его можно посмотреть с помощью команды `top -p 1`.
- **4.** Для этого необходимо отркыть новую сессию терминала, выяснить номер с помощью команды `tty` - которая вернёт нам вывод `/dev/pts/1`, после этого сможем перенаправить ошибку на другой терминал с помощью команды `ls '123' 2> /dev/pts/1`, в нашем другом окне терминала выведется ошибка `ls: cannot access '123': No such file or directory`.
- **5.** Исправил, сделал другой вывод:
```
vagrant@vagrant:~$ cat 1234.txt
test
vagrant@vagrant:~$ cat 12345.txt
cat: 12345.txt: No such file or directory
vagrant@vagrant:~$ cat < 1234.txt > 12345.txt
vagrant@vagrant:~$ cat 12345.txt
test
```
- **6.** Да мы можем передать вывод на другой терминал используя /dev/tty1, например:
```
vagrant@vagrant:~$ tty
/dev/pts/1
vagrant@vagrant:~$ echo tst > /dev/tty1
```
Вывод сообщения 'tst' уйдёт на наш другой терминал.
- **7.** Командой `bash 5>&1` мы создали файловый дескриптор, который прописался в /proc/$$/fd/5, следовательно переслав на этот файл вывод echo мы получим следующий результат:
```
vagrant@vagrant:~$ echo netology > /proc/$$/fd/5
netology
```
- **8.** Попробовал сделать это одной строкой с новым дескриптором 5(сначала вывод ошибок stderr 5>&2, потом stderr в sdtout 2>&1 и вывод в дескриптор 1>&5):
```
vagrant@vagrant:~$ cat 1234.txt 5>&2 2>&1 1>&5 | grep test
test
```
- **9.** Вывод команды `cat /proc/$$/environ` отобразит следующее:
```
vagrant@vagrant:~$ cat /proc/$$/environ
USER=vagrantLOGNAME=vagrantHOME=/home/vagrantPATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/tmp/new_path_directory:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/binSHELL=/bin/bashTERM=xterm-256colorXDG_SESSION_ID=3XDG_RUNTIME_DIR=/run/user/1000DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/busXDG_SESSION_TYPE=ttyXDG_SESSION_CLASS=userMOTD_SHOWN=pamLANG=en_US.UTF-8SSH_CLIENT=10.0.2.2 64334 22SSH_CONNECTION=10.0.2.2 64334 10.0.2.15 22SSH_TTY=/dev/pts/0
```
Это вывод переменных окружения текущей сессии, также просмотреть их в более удобном виде можно с помощью команды `printenv`.
- **10.** В `/proc/<PID>/cmdline` содержатся файлы только для чтения содержащие полную информацию о процессе, если это зомби процесс то содержимого файла не будет отображаться, например:
```
vagrant@vagrant:~$ cat /proc/842/cmdline
/usr/sbin/VBoxService--pidfile/var/run/vboxadd-service.shroot@vagrant:/home/vagrant#
```
В `/proc/<PID>/exe` содержатся символические ссылки на сами работающие программы, например:
```
vagrant@vagrant:~$ ls -lt /proc/842/exe
lrwxrwxrwx 1 root root 0 Feb 12 20:20 /proc/842/exe -> /opt/VBoxGuestAdditions-6.1.30/sbin/VBoxService
```
- **11.** Судя по выводу команды `cat /proc/cpuinfo` поддерживается набор инструкций sse4_2.
- **12.** По умолчанию для команды ssh не предусмотрено выделение псевдотерминала, поэтому выдаётся сообщение об ошибке, чтобы этого избежать можно использовать ключ `-t`:
```
vagrant@vagrant:~$ ssh -t localhost 'tty'
vagrant@localhost's password:
/dev/pts/1
Connection to localhost closed.
```
- **13.** Удалось запустить `sleep 1h` в другом терминале и подключиться к нему, выполнил команду `echo 0 > /proc/sys/kernel/yama/ptrace_scope`:
```
root@vagrant:/home/vagrant# ps aux | grep sleep
vagrant     2221  0.0  0.0   5476   596 pts/2    S+   16:54   0:00 sleep 1h
root        2223  0.0  0.0   6432   676 pts/0    R+   16:54   0:00 grep --color=auto sleep
root@vagrant:/home/vagrant# sudo reptyr -T 2221

```
- **14.** Командой `tee` можно записывать вывод в файл. Команда `sudo` позволяет выполнять другие команды с правами суперпользователя - root, поэтому команда `echo string | sudo tee /root/new_file` выполнится, так как у суперпользователя есть доступ к директории /root/.

# ДЗ 3.3. Операционные системы, лекция 1
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

# ДЗ 3.4. Операционные системы, лекция 2
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

# ДЗ 3.5. Файловые системы
- **1.** Разряженный файл помогает экономить место на диске блягодаря тому, что система высвобождает место, которое занято в таком файле только нулями.
- **2.** Не могут, так как жесткая ссылка это ссылка на тот же самый изначальный файл, как и говорилось на лекции их стоит воспринимать как одни и те же объекты.
- **3.** Сделано, выводы `fdisk -l /dev/sdb` и `fdisk -l /dev/sdc`:
```
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```
- **4.** Создано с помощью fdisk:
```
root@vagrant:/home/vagrant# fdisk /dev/sdb
n
p
1
+2G

n
p
2
w

root@vagrant:/home/vagrant# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop /snap/core18/2128
loop1                       7:1    0 70.3M  1 loop /snap/lxd/21029
loop3                       7:3    0 55.5M  1 loop /snap/core18/2284
loop4                       7:4    0 43.6M  1 loop /snap/snapd/14978
loop5                       7:5    0 61.9M  1 loop /snap/core20/1361
loop6                       7:6    0 67.9M  1 loop /snap/lxd/22526
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm  /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
└─sdb2                      8:18   0  511M  0 part
sdc                         8:32   0  2.5G  0 disk
```
- **5.** Сделано:
```
root@vagrant:/home/vagrant# sfdisk -d /dev/sdb | sfdisk /dev/sdc
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x53ee6d2c

Old situation:

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new DOS disklabel with disk identifier 0x3bf3a1e8.
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: dos
Disk identifier: 0x3bf3a1e8

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```
- **6.** Готово:
```
root@vagrant:/home/vagrant# mdadm --create --verbose /dev/md1 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: size set to 2094080K
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
root@vagrant:/home/vagrant# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md1 : active raid1 sdc1[1] sdb1[0]
      2094080 blocks super 1.2 [2/2] [UU]

unused devices: <none>
```
- **7.** Готово:
```
root@vagrant:/home/vagrant# mdadm --create --verbose /dev/md0 --level=0 --raid-devices=2 /dev/sdb2 /dev/sdc2
mdadm: chunk size defaults to 512K
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
root@vagrant:/home/vagrant# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md0 : active raid0 sdc2[1] sdb2[0]
      1042432 blocks super 1.2 512k chunks

md1 : active raid1 sdc1[1] sdb1[0]
      2094080 blocks super 1.2 [2/2] [UU]

unused devices: <none>
```
- **8.** Создано:
```
root@vagrant:/home/vagrant# pvcreate /dev/md1
  Physical volume "/dev/md1" successfully created.
root@vagrant:/home/vagrant# pvcreate /dev/md0
  Physical volume "/dev/md0" successfully created.
```
- **9.** Создано:
```
root@vagrant:/home/vagrant# vgcreate vg1 /dev/md1 /dev/md0
  Volume group "vg1" successfully created
```
- **10.** Создано:
```
root@vagrant:/home/vagrant# lvcreate -L 100M vg1 /dev/md0
  Logical volume "lvol0" created.
root@vagrant:/home/vagrant# lvs
  LV        VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  ubuntu-lv ubuntu-vg -wi-ao----  31.50g

  lvol0     vg1       -wi-a----- 100.00m
```
- **11.** Создано:
```
root@vagrant:/home/vagrant# mkfs.ext4 /dev/vg1/lvol0
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
```
- **12.** Готово:
```
root@vagrant:/home/vagrant# mkdir /tmp/new
root@vagrant:/home/vagrant# mount /dev/vg1/lvol0 /tmp/new
root@vagrant:/home/vagrant# df -h
Filesystem                         Size  Used Avail Use% Mounted on
udev                               447M     0  447M   0% /dev
tmpfs                               99M 1016K   98M   2% /run
/dev/mapper/ubuntu--vg-ubuntu--lv   31G  3.7G   26G  13% /
tmpfs                              491M     0  491M   0% /dev/shm
tmpfs                              5.0M     0  5.0M   0% /run/lock
tmpfs                              491M     0  491M   0% /sys/fs/cgroup
/dev/loop0                          56M   56M     0 100% /snap/core18/2128
/dev/loop1                          71M   71M     0 100% /snap/lxd/21029
/dev/sda2                          976M  107M  803M  12% /boot
vagrant                            238G  164G   75G  69% /vagrant
/dev/loop3                          56M   56M     0 100% /snap/core18/2284
/dev/loop4                          44M   44M     0 100% /snap/snapd/14978
/dev/loop5                          62M   62M     0 100% /snap/core20/1361
tmpfs                               99M     0   99M   0% /run/user/1000
/dev/loop6                          68M   68M     0 100% /snap/lxd/22526
/dev/mapper/vg1-lvol0               93M   72K   86M   1% /tmp/new
```
- **13.** 
```
root@vagrant:/home/vagrant# wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2022-02-28 18:03:28--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 22343665 (21M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

/tmp/new/test.gz     100%[=====================>]  21.31M  2.47MB/s    in 8.7s

2022-02-28 18:03:37 (2.45 MB/s) - ‘/tmp/new/test.gz’ saved [22343665/22343665]

root@vagrant:/home/vagrant# ls /tmp/new/
lost+found  test.gz
```
- **14.** Вывод `lsblk`:
```
root@vagrant:/home/vagrant# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop  /snap/core18/2128
loop1                       7:1    0 70.3M  1 loop  /snap/lxd/21029
loop3                       7:3    0 55.5M  1 loop  /snap/core18/2284
loop4                       7:4    0 43.6M  1 loop  /snap/snapd/14978
loop5                       7:5    0 61.9M  1 loop  /snap/core20/1361
loop6                       7:6    0 67.9M  1 loop  /snap/lxd/22526
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part  /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
└─sdb2                      8:18   0  511M  0 part
  └─md0                     9:0    0 1018M  0 raid0
    └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/new
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
└─sdc2                      8:34   0  511M  0 part
  └─md0                     9:0    0 1018M  0 raid0
    └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/new
```
- **15.** Вывод аналогично даёт 0.
- **16.** Выполнено:
```
root@vagrant:/home/vagrant# pvmove /dev/md0
  /dev/md0: Moved: 24.00%
  /dev/md0: Moved: 100.00%
```
- **17.** Сделано:
```
root@vagrant:/home/vagrant# mdadm /dev/md1 --fail /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md1
root@vagrant:/home/vagrant# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md0 : active raid0 sdc2[1] sdb2[0]
      1042432 blocks super 1.2 512k chunks

md1 : active raid1 sdc1[1] sdb1[0](F)
      2094080 blocks super 1.2 [2/1] [_U]

unused devices: <none>
```
- **18.** Вывод `dmesg | grep md/raid1`:
```
root@vagrant:/home/vagrant# dmesg | grep md/raid1
[ 7940.327658] md/raid1:md1: not clean -- starting background reconstruction
[ 7940.327659] md/raid1:md1: active with 2 out of 2 mirrors
[ 8973.196785] md/raid1:md1: Disk failure on sdb1, disabling device.
               md/raid1:md1: Operation continuing on 1 devices.
```
- **19.** Возвращает 0 (добавил скрин dz_3_5.PNG)

# ДЗ 3.6. Компьютерные сети, лекция 1
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
# ДЗ 3.7. Компьютерные сети, лекция 2
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

# ДЗ 3.8. Компьютерные сети, лекция 3
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

# ДЗ 3.9. Элементы безопасности информационных систем
- **1.** Готово, скрин DZ_3_9-1.PNG
- **2.** Готово, скрин DZ_3_9-2.PNG
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
Создать пару ключ сертификат - `openssl req -x509 -nodes -days 365 -newkey rsa:2048 \-keyout /etc/ssl/private/apache-selfsigned.key \-out /etc/ssl/certs/apache-selfsigned.crt`. После создания пары их можно использовать в нашем вебсервере, я использовал ключ и сертификат в самом apache2 - скриншот DZ_3_9-3.PNG.
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
- **7.** Выполнил запись с помощью команды `root@vagrant:/home/vagrant# tcpdump -i eth1 -c 100 -w 0001.pcap`. Скрин с Wireshark - DZ_3_9-4.PNG
