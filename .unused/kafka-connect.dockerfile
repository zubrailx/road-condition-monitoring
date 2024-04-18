FROM confluentinc/cp-kafka-connect:7.6.1

RUN confluent-hub install --no-prompt --verbose clickhouse/clickhouse-kafka-connect:v1.0.16

ENV CONNECT_PLUGIN_PATH="/usr/share/java,/usr/share/confluent-hub-components"
