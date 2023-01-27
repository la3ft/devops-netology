# Домашнее задание к занятию "11.02 Микросервисы: принципы"

Вы работаете в крупной компанию, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps специалисту необходимо выдвинуть предложение по организации инфраструктуры, для разработки и эксплуатации.

## Задача 1: API Gateway 

Предложите решение для обеспечения реализации API Gateway. Составьте сравнительную таблицу возможностей различных программных решений. На основе таблицы сделайте выбор решения.

Решение должно соответствовать следующим требованиям:
- Маршрутизация запросов к нужному сервису на основе конфигурации
- Возможность проверки аутентификационной информации в запросах
- Обеспечение терминации HTTPS

Обоснуйте свой выбор.

## Задача 2: Брокер сообщений

Составьте таблицу возможностей различных брокеров сообщений. На основе таблицы сделайте обоснованный выбор решения.

Решение должно соответствовать следующим требованиям:
- Поддержка кластеризации для обеспечения надежности
- Хранение сообщений на диске в процессе доставки
- Высокая скорость работы
- Поддержка различных форматов сообщений
- Разделение прав доступа к различным потокам сообщений
- Протота эксплуатации

Обоснуйте свой выбор.

## Ответы:
### 1.

| Gateway API | Маршрутизация запросов | Аутентификация | Терминация HTTPS | Бесплатное |
|:---:|:---:|:---:|:---:|:---:|
| Tyk                    | +  | +  | +  | +  |
| Gravitee.io            | +  | +  | +  | +  |
| APISIX                 | +  | +  | +  | +  |
| Apigee                 | +  | +  | +  | - |
| Kong                   | +  | +  | +  | +  |
| Ambassador             | +  | +  | +  | - |
| Gloo                   | +  | +  | +  | - |
| MuleSoft               | +  | +  | +  | - |
| Axway                  | +  | +  | +  | - | 
| Istio                  | +  | +  | +  | +  |
| Young App              | +  | +  | +  | - |
| SnapLogic              | +  | +  | +  | - |
| Akana API Platform     | +  | +  | +  | - |
| Oracle API Platform    | +  | +  | +  | - |
| TIBCO Cloud-Mashery    | +  | +  | +  | - |
| 3scale                 | +  | +  | +  | - |
| Google API Platform    | +  | +  | +  | - |
| SberCloud API Gateway  | +  | +  | +  | - |
| Amazon API Gateway     | +  | +  | +  | - |
| Aliyun                 | +  | +  | +  | - |
| Yandex API Gateway     | +  | +  | +  | - |
| Azure API Management   | +  | +  | +  | - |

На мой взгляд самым подходящим будет Kong - бесплатен, имеется широкая документация, большой размер сообщества, а также решение основано на Nginx, по которому также много документации.

### 2.

| Возможности | Apache Kafka | RabbitMQ | Redis | ActiveMQ |
|:---:|:---:|:---:|:---:|:---:
| Поддержка кластеризации для обеспечения надежности | + | + | + | + |
| Хранение сообщений на диске в процессе доставки | + | + | + | + |
| Высокая скорость работы | + | + | + | - |
| Поддержка различных форматов сообщений | BINARY on TCP | STOMP/AMQP/MQTT |  RESP | AMQP//MQTT/RESP и пр. |
| Разделение прав доступа к различным потокам сообщений | + | + | + | + |
| Простота эксплуатации | - | + | + | + |

Под все требования подходит Apache Kafka - он является наиболее масштабируемым, на данный момент решение является практически стандартом для многих проектов, что также не должно вызывать проблем с поиском документации и решением частых проблем.