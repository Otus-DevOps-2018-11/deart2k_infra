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