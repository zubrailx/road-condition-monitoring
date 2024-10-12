# road-condition-monitoring

## RU

Система мониторинга состояния дорог (road-condition-monitoring) предназначена для сбора данных с датчиков (акселерометр, гироскоп, GPS) мобильных устройств с целью прогнозирования состояния дорожного покрытия. Прогнозирование осуществляется специализированным сервисом (не мобильным устройством). Пользователи, указав адрес сервиса `api`, могут получать результаты прогнозов о состоянии дорожного покрытия в точках прогноза.

Разработанные компоненты:
- `api` – предоставляет результаты пользователям.
- `guessr` – выполняет прогнозирование на основе данных с датчиков мобильных устройств.
- `mobile` – мобильное приложение, разработанное на Flutter, собирающее данные с датчиков и позволяющее просматривать результаты анализа.
- `points_consumer` – сервис, группирующий результаты прогнозирования для снижения нагрузки на базу данных.

Опциональные компоненты:
- `monitoring_imitator` – вспомогательный сервис для нагрузочного тестирования `guessr` и `points_consumer`.
- `monitoring_keeper` и `monitoring_loader` – используются для хранения промежуточных результатов во время тестирования алгоритмов `guessr`.

Используемые сервисы:
- `kafka` – очередь сообщений, обеспечивающая связь между `guessr`, `mobile` и `points_consumer`.
- `clickhouse` – СУБД для хранения результатов прогнозирования.

Дополнительные сервисы:
- `kafkaui` – интерфейс для просмотра состояния очереди `kafka`.

## EN

The road-condition-monitoring system is designed to collect sensor data (accelerometer, gyroscope, GPS) from mobile devices to predict road surface conditions. The prediction is performed by a specialized service responsible for forecasting. Users, by specifying the `api` service's address, can obtain forecast results about road conditions at the prediction points.

Developed components:
- `api` – provides data to users.
- `guessr` – makes predictions based on sensor data.
- `mobile` – a mobile application that collects sensor data and allows users to view analysis results.
- `points_consumer` – a service that groups prediction results to reduce the load on the database.

Optional components:
- `monitoring_imitator` – an auxiliary service for load testing `guessr` and `points_consumer`.
- `monitoring_keeper` and `monitoring_loader` – used for storing intermediate results during the testing of `guessr` algorithms.

Services used:
- `kafka` – a message queue used for communication between `guessr`, `mobile`, and `points_consumer`.
- `clickhouse` – a DBMS for storing prediction results.

Additional services:
- `kafkaui` – an interface for viewing the state of the `kafka` queue.


## Build & Deploy

Services:

```sh
docker compose \
    [--profile monitoring-keeper] \
    [--profile monitoring-loader] \
    [--profile mobile-imitator] \
    build

docker compose \
    [--profile monitoring-keeper] \
    [--profile monitoring-loader] \
    [--profile mobile-imitator] \
    up
```

> `points-consumer` may require manual restart after kafka is ready, otherwise won't read topics.
> ```sh
> docker compose restart points-consumer
> ```

Mobile:

```sh
cd mobile
flutter build apk
```

## Datasets

- Jeferson Menegazzo. (2021). PVS - Passive Vehicular Sensors Datasets [Data set]. Kaggle. https://doi.org/10.34740/KAGGLE/DS/1105310
