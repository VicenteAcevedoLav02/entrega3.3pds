# config/initializers/mqtt_client.rb
require 'mqtt'

# Configuración del broker HiveMQ
MQTT_CLIENT = MQTT::Client.connect(
  host: '9edcfed806b14ab5a57aead4a616d086.s1.eu.hivemq.cloud',         # Cambia por el hostname de HiveMQ
  port: 8883,                  # Puerto seguro (usualmente 8883 para TLS)
  username: 'rails_server',      # Nombre de usuario en HiveMQ
  password: 'rails123',   # Contraseña en HiveMQ
  ssl: true                    # Usar SSL para conexiones seguras
)
