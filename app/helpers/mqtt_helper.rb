module MqttHelper

  def send_mqtt_command topic, message, options: { 
    client: MQTT::Client.new, 
    host: Rails.application.secrets.mqtt_host,
    port: '8883', 
    username: Rails.application.secrets.mqtt_username, 
    password: Rails.application.secrets.mqtt_password, 
    ssl: true }

    # Define connection
    client          = options[:client]
    client.host     = options[:host]
    client.port     = options[:port]
    client.username = options[:username] 
    client.password = options[:password] 
    client.ssl      = options[:ssl] 

    logger.info "Client: #{client}"
    logger.info "MQTT Host: #{client.host}"
    logger.info "MQTT Username: #{client.username}"
    logger.info "MQTT SSL: #{client.ssl}"

    client.connect() do |c|
      c.publish(topic, message)
    end
  end
end
