class MqttMailer < ApplicationMailer
    default from: 'vichoacevedo@gmail.com'  # Cambia a tu dirección de correo
  
    # Método para enviar el correo con el JSON recibido
    def json_update_email(json_data)
      @json_data = json_data
      mail(
        to: 'vichoacevedo@gmail.com',  # Cambia a la dirección de correo destinatario
        subject: 'Actualización de JSON recibido',
        body: "El siguiente JSON ha sido recibido: #{@json_data}"
      )
    end
  end
  