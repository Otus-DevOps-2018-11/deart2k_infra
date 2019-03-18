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


Выполнено ДЗ №9

[+ ] Основное ДЗ
[- ] ДЗ *

В процессе сделано:
Создание инфраструктуры в одном сценарии
Создание инфраструктуры в нескольких сценариях
Создание инфраструктуры в нескольких плейбуках
Перевод packer провижн на ansible модули

Как запустить проект:
Запустить команду
ansible-playbook site.yml

Как проверить работоспособность:
Открыть страницу приложения по ссылке http://ip_address_app:9292/

Выполнено ДЗ № 10

    [+] Основное ДЗ

В процессе сделано:


  - на основе плейбуков созданы ansible-роли app и db  
  - созданы окружения {prod,stage}
  - организован каталог ansible
        плейбуки перенесены в /ansible/playbooks
        прочие файлы перенесены в /ansible/old
  - Установлена комьюнити роль nginx (ansible-galaxy).
  - добавлен плейбук для создания пользователй, использован Ansible Vault для шифровки данных добавляемых пользователей.

Выполнено ДЗ №11.  Локальная разработка Ansible ролей с Vagrant. Тестирование конфигурации
В процессе сделано:
  - Установлен vagrant
  - Созданы вм appserver и dbserver с помощью vagrant
  - Добавлен base.yml для установки python
  - Доработана роль db, добалены файлы тасков install_mongo.yml и config_mongo.yml
  - Доработана роль app, добалены файлы тасков puma.yml и ruby.yml. Параметризировано имя пользователя
Задание со *
  - Дополнена конфигурация Vagrant для корректной работы проксирования приложения с помощью nginx

  - установлен molecule
  - Использована команда molecule init scenario --scenario-name default -r db -d vagrant для создания заготовки тестов для роли db
  - Добавлены тесты, используя модули Testinfra
  - Добавлен тест к роли db для проверки того, что БД слушает по нужному порту (27017)
  - внесены правки в packer_db.yml и packer_app.yml
