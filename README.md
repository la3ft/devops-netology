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
- **4.** 
- **5.** 
- **6.** 
- **7.** 
- **8.** 
- **9.** Вывод команды `cat /proc/$$/environ` отобразит следующее:
```
vagrant@vagrant:~$ cat /proc/$$/environ
USER=vagrantLOGNAME=vagrantHOME=/home/vagrantPATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/tmp/new_path_directory:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/binSHELL=/bin/bashTERM=xterm-256colorXDG_SESSION_ID=3XDG_RUNTIME_DIR=/run/user/1000DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/busXDG_SESSION_TYPE=ttyXDG_SESSION_CLASS=userMOTD_SHOWN=pamLANG=en_US.UTF-8SSH_CLIENT=10.0.2.2 64334 22SSH_CONNECTION=10.0.2.2 64334 10.0.2.15 22SSH_TTY=/dev/pts/0
```
Это вывод переменных окружения текущего пользователя, также просмотреть их в более удобном виде можно с помощью команды `printenv`.
- **10.** 
- **11.** 
- **12.** 
- **13.** 
- **14.** 
