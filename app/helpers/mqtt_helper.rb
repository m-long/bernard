module MqttHelper
  client          = MQTT::Client.new
  client.host     = 'mqtt.mattlong.la'
  client.port     = '8883'
  client.username = Rails.application.secrets.mqtt_username
  client.password = Rails.application.secrets.mqtt_password
  client.ssl      = true

  def send_mqtt_command topic, message
    client.connect() do
      c.publish(topic, message)
    end
  end
end
