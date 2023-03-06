# Домашнее задание к занятию "12.4 Развертывание кластера на собственных серверах, лекция 2"
Новые проекты пошли стабильным потоком. Каждый проект требует себе несколько кластеров: под тесты и продуктив. Делать все руками — не вариант, поэтому стоит автоматизировать подготовку новых кластеров.

## Задание 1: Подготовить инвентарь kubespray
Новые тестовые кластеры требуют типичных простых настроек. Нужно подготовить инвентарь и проверить его работу. Требования к инвентарю:
* подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды;
* в качестве CRI — containerd;
* запуск etcd производить на мастере.

## Ответ:
Исходная инструкция: https://github.com/la3ft/kubernetes-for-beginners/tree/master/15-install/30-kubespray  
Установим kubespray, необходимые зависимости для него и сконфигурируем yaml инвентарь:
```
git clone https://github.com/kubernetes-sigs/kubespray
cd kubespray
sudo pip3 install -r requirements.txt
cp -rfp inventory/sample inventory/mycluster
declare -a IPS=(192.168.3.254 192.168.3.2 192.168.3.3 192.168.3.4 192.168.3.5)
CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
```
Поправим получившийся hosts.yaml:
```
vim inventory/mycluster/hosts.yaml
```
```[yaml]
all:
  hosts:
    node1:
      ansible_host: 192.168.3.254
      ansible_user: laft
    node2:
      ansible_host: 192.168.3.2
      ansible_user: laft
    node3:
      ansible_host: 192.168.3.3
      ansible_user: laft
    node4:
      ansible_host: 192.168.3.4
      ansible_user: laft
    node5:
      ansible_host: 192.168.3.5
      ansible_user: laft
  children:
    kube_control_plane:
      hosts:
        node1:
    kube_node:
      hosts:
        node2:
        node3:
        node4:
        node5:
    etcd:
      hosts:
        node1:
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}
```
Запустить плэйбук:
```
ansible-playbook -i inventory/mycluster/hosts.yaml cluster.yml -b -v -kK
```
