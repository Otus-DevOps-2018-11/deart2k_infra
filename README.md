# deart2k_infra
deart2k Infra repository


## Домашнее задание №3  

### подключение к someinternalhost в одну команду   

```ssh -A -t appuser@35.210.152.27 ssh 10.132.0.3 ```  

Где:  
- appuser — имя пользователя  
- 35.210.152.27 —  внешний ip адрес хоста bastion  
- 10.132.0.3  — внутренний ip адрес хостаsomeinternalhost  

### подключение из консоли при помощи команды вида ssh someinternalhost (по алиасу)

Вариант 1 (не полностью удовлетваряет условию но первым пришел в голову)

```
export someinternalhost='-t -A appuser@35.210.152.27 ssh 10.132.0.3'

ssh $someinternalhost
```

Вариант 2 (более правильный)

Добавляем в ~/.ssh/config  

```bash

Host bastion
    HostName 35.210.152.27
    User appuser

Host someinternalhost
    ProxyCommand ssh -A bastion -W 10.132.0.3 
    User appuser

```

и выполняем комманду 
```bash
ssh someinternalhost
```

### подключение к vpn  

```bash

bastion_IP = 35.210.152.27
someinternalhost_IP = 10.132.0.3

```
## ДЗ №4  

testapp_IP = 35.240.87.11
testapp_port = 9292


### Дополнительные задания  

#### № 1 
#### После выполнения данной команды gcloud получаем вм с уже запущенным приложением  

```bash

gcloud compute instances create reddit-app \
--boot-disk-size=10GB \
--image-family ubuntu-1604-lts \
--image-project=ubuntu-os-cloud \
--machine-type=g1-small \
--tags puma-server \
--restart-on-failure \
--metadata-from-file startup-script=startup-script.sh

```

#### Добавляем правило firewall из консоли с помощью gcloud

```bash

gcloud compute firewall-rules create default-puma-server \
--direction=INGRESS \
--priority=1000 \
--network=default \
--action=ALLOW \
--rules=tcp:9292 \
--source-ranges=0.0.0.0/0 \
--target-tags=puma-server

```


## ДЗ №6 

Практика IaC с использованием Terraform

Задания со *

#### Опишите в коде терраформа добавление ssh ключа пользователя appuser1 в метаданные проекта. Выполните terraform apply и проверьте результат (публичный ключ можно брать пользователя appuser)  

```bash
resource "google_compute_project_metadata_item" "default" {
  key   = "ssh-keys"
  value = "appuser1:${file(var.public_key_path)}"
}

```

В результате публичный ключ пользователя appuser1 появился в метаданных проекта и его можно исмользовать для всех vm проекта



#### Опишите в коде терраформа добавление ssh ключей нескольких пользователей в метаданные проекта, например appuser1, appuser2 и т.д.). Выполните terraform apply и проверьте №№№№№результат

```bash

resource "google_compute_project_metadata_item" "default" {
  key   = "ssh-keys"
  value = "appuser1:${file(var.public_key_path)} appuser2:${file(var.public_key_path)} appuser3:${file(var.public_key_path)}"
}

```

В результате все перечисленные публичные ключи пользователей появился в метаданных проекта и их можно исмользовать для всех vm проекта

##### Добавьте в веб интерфейсе ssh ключ пользователю appuser_web в метаданные проекта. Выполните terraform apply и проверьте результат

В результате выполнения команды terraform apply ключ добавленный через web-интерфейс был удалён.

Задания со * 2

Создан файл lb.tf в которов описано создание HTTP балансировщик. Добавлено создание инстаносов через count. В  output  переменные добавлены вывод адресов всех вм и адрес балансировщика.

Какие проблемы вы видите в такой конфигурации приложения?

У каждого экзкпляра приложения своя бд




Выполнено ДЗ № 7

Terraform: ресурсы, модули, окружения и работа в команде

    [+ ] Основное ДЗ

- созданы два описания конфигурации образа для packer (app.json, db.json)
- созданы 2 конфигурации terraform для приложения и БД;
- конфигурация и деплой приложения и бд, а также сетевые настройки предаставлены в виде модулей (app, db, vpc);
- созданы два окружения stage (доступный с ограниченного числа IP-адресов) и prod, доступный всем;
- создана когфигурация storage-bucket.tf для создания бакетов в GCS;


Выполнено ДЗ № 8

[+ ] Основное ДЗ
[+ ] ДЗ *
В процессе сделано:

Установлен Ansible 

Созданы файлы invertory (стандартный и yml)

Создан конфигурационный файл ansible.cfg со значениями по умолчанию для проекта

Создан ansible playbook, описанный в clone.yml, для проверки поведения ansible для повторяющихся задач.

Задание со *:
создан скрипт dyninventory.py для создания динамического invertory в формате json(данные берутся из terraform из папки stage) и ansible.cfg этот скрипт указан по умолчанию
для работы скрипта необходимо установить модуль python_terraform
