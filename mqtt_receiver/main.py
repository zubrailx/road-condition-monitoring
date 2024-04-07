import paho.mqtt.client as mqtt
import sys

from paho.mqtt.enums import CallbackAPIVersion


if (len(sys.argv) < 3):
    print('host args are not passed')
    exit(-1);

TOPIC = "monitoring"

MQTT_HOST = sys.argv[1]
MQTT_PORT = int(sys.argv[2])

def on_connect(client, userdata, flags, reason_code, properties):
    print(f"Connected with result code {reason_code}")
    client.subscribe(TOPIC)


def on_message(client, userdata, msg):
    print(msg.topic + " " + str(msg.payload))


mqttc = mqtt.Client(CallbackAPIVersion.VERSION2)
mqttc.on_connect = on_connect
mqttc.on_message = on_message

mqttc.connect(MQTT_HOST, MQTT_PORT, 60)

mqttc.loop_forever()