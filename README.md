
# Скрипт для инициализации метрик PostgreSQL на основе postgres_exporter

🚀 Этот скрипт позволяет инициализировать метрики PostgreSQL с использованием postgres_exporter.

## Инициализация виртуальной машины

Для работы с виртуальной машиной используется Vagrant с провайдером VirtualBox. 

### Изменение настроек Vagrant

В `Vagrantfile` вы можете изменить данные для базы данных PostgreSQL. 

### Инициализация

Перейдите в папку "vagrant" и выполните команду `vagrant up`. Машина будет автоматически проинициализирована с установленными Docker, Prometheus и Grafana. Чтобы завершить установку Golang, выполните следующие команды:

```bash
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
source ~/.profile
```

## Использование скрипта

### Изменение параметров

В файле со скриптом необходимо поменять строчки инициализации базы данных для того, чтобы сервис смог собирать метрики с вашей бд:

```bash
USER=username
PASSWORD=password
DB_NAME=db_name
```

### Использование

Для начала необходимо выдать скрипту права доступа:

```bash
chmod +x metrics_init.sh
```

Затем запустите скрипт с правами администратора:

```bash
sudo ./metrics_init.sh
```
