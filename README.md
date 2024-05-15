# road-condition-monitoring

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
