import paho.mqtt.client as mqtt
from paho.mqtt.enums import CallbackAPIVersion

TOPIC = "monitoring"

def on_connect(client, userdata, flags, reason_code, properties):
    print(f"Connected with result code {reason_code}")
    client.subscribe(TOPIC)


def on_message(client, userdata, msg):
    print(msg.topic + " " + str(msg.payload))


mqttc = mqtt.Client(CallbackAPIVersion.VERSION2)
mqttc.on_connect = on_connect
mqttc.on_message = on_message

mqttc.connect("localhost", 1883, 60)

mqttc.loop_forever()
