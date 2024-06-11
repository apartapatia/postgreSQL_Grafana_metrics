#!/bin/bash

# Параметры базы данных
USER=just_ai
PASSWORD=just_ai
DB_NAME=users_db

# Скачивание и проверка работоспособности докер образа
docker pull quay.io/prometheuscommunity/postgres-exporter
docker run -d --name postgres_exporter -p 9187:9187 --net=host -e DATA_SOURCE_NAME="postgresql://$USER:$PASSWORD@localhost:5432/$DB_NAME?sslmode=disable" wrouesnel/postgres_exporter

sleep 5
if [ $(docker inspect -f '{{.State.Running}}' postgres_exporter) != "true" ]; then
    echo "Error starting postgres-exporter container."
    exit 1
fi

# Перезапуск демонов
sudo systemctl daemon-reload

# IP адрес
IP_ADDR=$(ip addr | grep -Po 'inet \K192\.\d+\.\d+\.\d+')

# Обновление конфигурации прометеуса
PROMETHEUS_CONFIG="/etc/prometheus/prometheus.yml"
if ! grep -q 'job_name: pg' $PROMETHEUS_CONFIG; then
    echo "Updating Prometheus configuration..."
    sudo bash -c "cat >> $PROMETHEUS_CONFIG <<EOL
  - job_name: pg
    static_configs:
      - targets: ['$IP_ADDR:9187']
EOL"
fi

# Перезапуск сервиса прометеуса
sudo systemctl restart prometheus

# Проверка всех сервисов на доступность
SERVICES=("prometheus" "docker" "postgresql" "grafana-server")

for service in "${SERVICES[@]}"; do
    if systemctl is-active --quiet $service; then
        echo "Service $service is running."
    else
        echo "Service $service is not running!"
    fi
done

echo "Script executed successfully."
