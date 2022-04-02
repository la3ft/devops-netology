# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис  
  Исправление:
```json
{
	"info": "Sample JSON output from our service\t",
	"elements": [
		{
			"name": "first",
			"type": "server",
			"ip": 7175
		},
		{
			"name": "second",
			"type": "proxy",
			"ip": "71.78.22.43"
		}
	]
}
```

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
import socket, json, yaml

hosts = {'drive.google.com':'0.0.0.0', 'mail.google.com':'0.0.0.0', 'google.com':'0.0.0.0'}
actual = []

#Вывод текущих значений + запись их в справочник + запись в файлы 1.json и 2.yml
for host in hosts:
    ip = socket.gethostbyname(host)
    print(host+' '+ip)
    hosts[host] = ip
    actual.append({host:ip})
j = json.dumps(actual)
with open('1.json', 'w') as outfile:
    outfile.write(j)
with open('2.yml', 'w') as outfile:
    data = yaml.dump(actual, outfile)
#Цикл проверки соответствия, в случае изменения будет выведено соотвутствующее сообщение и выход из цикла + перезапись файлов 1.json и 2.yml
while 1==1:
  for host in hosts:
    ip = socket.gethostbyname(host)
    actual[:] = [d for d in actual if d.get(host) != ip]
    if ip != hosts[host]:
      print('[ERROR] ' + str(host) +' IP mistmatch: '+hosts[host]+' '+ip)
      for host in hosts:
          ip = socket.gethostbyname(host)
          hosts[host] = ip
          actual.append({host: ip})
      j = json.dumps(actual)
      with open('1.json', 'w') as outfile:
        outfile.write(j)
      with open('2.yml', 'w') as outfile:
        data = yaml.dump(actual, outfile)
      exit()
```

### Вывод скрипта при запуске при тестировании:
```
drive.google.com 142.250.150.194
mail.google.com 74.125.131.17
google.com 173.194.221.100
[ERROR] google.com IP mistmatch: 173.194.221.100 173.194.221.139
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
[{"drive.google.com": "142.250.150.194"}, {"mail.google.com": "74.125.131.17"}, {"google.com": "173.194.221.139"}]
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
- drive.google.com: 142.250.150.194
- mail.google.com: 74.125.131.17
- google.com: 173.194.221.139
```
