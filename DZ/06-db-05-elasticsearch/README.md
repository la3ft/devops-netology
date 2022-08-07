# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

### Ответ:
Последовательность команд:
```
root@vagrant:/home/vagrant# docker pull elasticsearch:7.17.5
root@vagrant:/home/vagrant# docker run -d --name elasticsearch -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch:7.17.5
root@vagrant:/home/vagrant# docker exec -u 0 -it 8dbde2dcc600 /bin/bash
root@8dbde2dcc600:/usr/share/elasticsearch# cd /usr/share/elasticsearch/config/
root@8dbde2dcc600:/usr/share/elasticsearch/config# mkdir /var/lib/elasticsearch_data
root@8dbde2dcc600:/usr/share/elasticsearch/config# mkdir /var/lib/elasticsearch_logs
root@8dbde2dcc600:/usr/share/elasticsearch/config# vim elasticsearch.yml
root@8dbde2dcc600:/usr/share/elasticsearch/config# cat elasticsearch.yml
cluster.name: "netology_test"
network.host: 0.0.0.0
path.data: /var/lib/elasticsearch_data
path.logs: /var/lib/elasticsearch_logs
root@vagrant:/home/vagrant# docker commit 8dbde2dcc600 la3ft/elastic:1.0
root@vagrant:/home/vagrant# docker image push la3ft/elastic:1.0
root@vagrant:/home/vagrant# docker run -d --name elasticsearch_my -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" la3ft/elastic:1.0
root@vagrant:/home/vagrant# docker exec -u 0 -it 321a45aa485a /bin/bash
root@321a45aa485a:/usr/share/elasticsearch# curl -X GET http://localhost:9200/
{
  "name" : "321a45aa485a",
  "cluster_name" : "netology_test",
  "cluster_uuid" : "CZFYkxdEQN2ZnSAcJ4ge2Q",
  "version" : {
    "number" : "7.17.5",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "8d61b4f7ddf931f219e3745f295ed2bbc50c8e84",
    "build_date" : "2022-06-23T21:57:28.736740635Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```
Созданная репа:
https://hub.docker.com/repository/docker/la3ft/elastic


## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

### Ответ:

Создать:
```
root@80483e8bdfe6:/# curl -X PUT localhost:9200/ind-1 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
root@80483e8bdfe6:/# curl -X PUT localhost:9200/ind-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 2,  "number_of_replicas": 1 }}'
root@80483e8bdfe6:/# curl -X PUT localhost:9200/ind-3 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 4,  "number_of_replicas": 2 }}'
```
Получение списка:
```
root@80483e8bdfe6:/# curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases 3dYnejPnQHK9bXJn3sBG2Q   1   0         39            0       37mb           37mb
green  open   ind-1            yacq-QErQMaDqyT32-0aFQ   1   0          0            0       226b           226b
yellow open   ind-3            UmhxlKnxRmeTwvT1H7a9eA   4   2          0            0       904b           904b
yellow open   ind-2            QGNS-HJlTNW5F8tCjosmbg   2   1          0            0       452b           452b
```
Получение статуса:
```
root@80483e8bdfe6:/# curl -X GET 'http://localhost:9200/_cluster/health/ind-1?pretty'
{
  "cluster_name" : "netology_test",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 1,
  "active_shards" : 1,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}
root@80483e8bdfe6:/# curl -X GET 'http://localhost:9200/_cluster/health/ind-2?pretty'
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 2,
  "active_shards" : 2,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 2,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
root@80483e8bdfe6:/# curl -X GET 'http://localhost:9200/_cluster/health/ind-3?pretty'
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 4,
  "active_shards" : 4,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 8,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
```
Статус кластера:
```
root@80483e8bdfe6:/# curl -XGET localhost:9200/_cluster/health/?pretty=true
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 10,
  "active_shards" : 10,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
```
Статус yellow из-за неподписанных шардов, значение "unassigned_shards", это в свою очередь из-за указанных реплик, хотя у нас по факту одна нода.

Удаление:
```
root@80483e8bdfe6:/# curl -X DELETE 'http://localhost:9200/ind-1?pretty'
{
  "acknowledged" : true
}
root@80483e8bdfe6:/# curl -X DELETE 'http://localhost:9200/ind-2?pretty'
{
  "acknowledged" : true
}
root@80483e8bdfe6:/# curl -X DELETE 'http://localhost:9200/ind-3?pretty'
{
  "acknowledged" : true
}
```

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

### Ответ:

Добавить строку в elasticsearch.yml:
```
path.repo: /usr/share/elasticsearch/snapshots
```
Создание и вывод: 
```
root@80483e8bdfe6:/# curl -XPOST localhost:9200/_snapshot/netology_backup?pretty -H 'Content-Type: application/json' -d'{"type": "fs", "settings": { "location":"/usr/share/elasticsearch/snapshots" }}'
{
  "acknowledged" : true
}
root@80483e8bdfe6:/# curl -XGET http://localhost:9200/_snapshot/netology_backup?pretty
{
  "netology_backup" : {
    "type" : "fs",
    "settings" : {
      "location" : "/usr/share/elasticsearch/snapshots"
    }
  }
}
```

Индекс и снепшот:

```
root@80483e8bdfe6:/# curl -X PUT localhost:9200/test -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"test"}

root@80483e8bdfe6:/# curl -XGET http://localhost:9200/test?pretty
{
  "test" : {
    "aliases" : { },
    "mappings" : { },
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "1",
        "provided_name" : "test",
        "creation_date" : "1659812723468",
        "number_of_replicas" : "0",
        "uuid" : "erVCTBbTSNyrEQhWg1g71Q",
        "version" : {
          "created" : "7170599"
        }
      }
    }
  }
}

root@80483e8bdfe6:/# curl -X PUT localhost:9200/_snapshot/netology_backup/elasticsearch?wait_for_completion=true
{"snapshot":{"snapshot":"elasticsearch","uuid":"GFJ9sH_vQrq_BtwGr0ZotA","repository":"netology_backup","version_id":7170599,"version":"7.17.5","indices":["test",".ds-ilm-history-5-2022.08.06-000001",".geoip_databases",".ds-.logs-deprecation.elasticsearch-default-2022.08.06-000001"],"data_streams":["ilm-history-5",".logs-deprecation.elasticsearch-default"],"include_global_state":true,"state":"SUCCESS","start_time":"2022-08-06T19:07:48.942Z","start_time_in_millis":1659812868942,"end_time":"2022-08-06T19:07:50.145Z","end_time_in_millis":1659812870145,"duration_in_millis":1203,"failures":[],"shards":{"total":4,"failed":0,"successful":4},"feature_states":[{"feature_name":"geoip","indices":[".geoip_databases"]}]}}

root@80483e8bdfe6:/# ll /usr/share/elasticsearch/snapshots
total 60
drwxrwxrwx 3 root          root  4096 Aug  6 19:07 ./
drwxrwxr-x 1 root          root  4096 Aug  6 18:55 ../
-rw-rw-r-- 1 elasticsearch root  1425 Aug  6 19:07 index-0
-rw-rw-r-- 1 elasticsearch root     8 Aug  6 19:07 index.latest
drwxrwxr-x 6 elasticsearch root  4096 Aug  6 19:07 indices/
-rw-rw-r-- 1 elasticsearch root 29235 Aug  6 19:07 meta-GFJ9sH_vQrq_BtwGr0ZotA.dat
-rw-rw-r-- 1 elasticsearch root   712 Aug  6 19:07 snap-GFJ9sH_vQrq_BtwGr0ZotA.dat
```

Удаление и создание нового индексов:
```
root@80483e8bdfe6:/# curl -X DELETE 'http://localhost:9200/test?pretty'
{
  "acknowledged" : true
}

root@80483e8bdfe6:/# curl -X PUT localhost:9200/test-2?pretty -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}
```
Восстановление из снепшота - 
У меня так и не получилось восстановить снэпшот, ругается на индекс истории -  cannot restore index [.ds-ilm-history-5-2022.08.06-000001] because an open index with same name already exists in the cluster. Погуглил что это из-за свойства indices.lifecycle.history_index_enabled, выставил его в false, перезапустился, проделал манипуляции с удалением и созданием заново - аналогичная ошибка..
