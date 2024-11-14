namespace :mqtt do
    desc "Listen to MQTT topics and store messages in the database"
    task listen: :environment do
      begin
        # Suscribirse a los tópicos
        MQTT_CLIENT.subscribe('esp32log', 'passwords')
        puts "Listening to the 'esp32log' and 'passwords' topics..."
    
        # Escuchar mensajes en un bucle
        MQTT_CLIENT.get do |topic, message|
          # Imprimir el mensaje recibido en consola
          puts "Received message on topic '#{topic}': #{message}"
          
          if topic == 'esp32log'
            Esp32Log.create!(
            message: message,
            received_at: Time.current
          )
          puts "Log saved to database: #{message}"
            # Analizar el mensaje recibido del tópico "esp32log"
            json_message = JSON.parse(message)
            locksub = json_message["locksub"]
            count2 = json_message["count2"]
            if count2.nil?
              puts "Error: count2 is nil. Cannot calculate event time."
              next # Saltamos esta iteración y continuamos esperando el siguiente mensaje
            end
  
            # Buscar el usuario cuyo locker_id coincida con locksub
            user = User.find_by(locker_id: locksub)
            if user
              # Calcular la hora del evento
              event_time = Time.current - count2.seconds
              event_time = Time.current - 3.hours
              formatted_time = event_time.strftime("%H:%M:%S")
              
              # Enviar correo con la alerta
              MqttMailer.locker_opened_alert(user, formatted_time, count2).deliver_now
              puts "Sent alert for locker #{locksub} to #{user.email}"
            else
              puts "No user found with locker_id #{locksub}"
            end
  
          elsif topic == 'passwords'
            # Analizar el mensaje recibido del tópico "passwords"
            json_message = JSON.parse(message)
            locker_id = json_message["5"]
  
            # Buscar el usuario cuyo locker_id coincida con el locker_id del JSON
            user = User.find_by(locker_id: locker_id)
            if user
              # Obtener la nueva contraseña del locker
              new_password = json_message[locker_id.to_s]
              # Enviar correo con la alerta de actualización de contraseña
              MqttMailer.password_update_alert(user, new_password).deliver_now
              puts "Sent password update alert for locker #{locker_id} to #{user.email}"
            else
              puts "No user found with locker_id #{locker_id}"
            end
          end
        end
    
      rescue => e
        puts "Error: #{e.message}"
        retry
      end
    end
  end
  