class MqttMailer < ApplicationMailer
    default from: 'vichoacevedo@gmail.com'  # Cambia a tu dirección de correo

def locker_opened_alert(user, formatted_time, count2)
    @user = user
    @formatted_time = formatted_time
    @count2 = count2

    mail(
    to: @user.email,
    subject: "Alerta de apertura de casillero"
    ) do |format|
    format.text { render plain: "Se notifica al usuario que su casillero ha sido abierto a la hora #{@formatted_time} durante #{@count2} segundos" }
    end
end
def password_update_alert(user, new_password)
    @user = user
    @new_password = new_password

    mail(
        to: @user.email,
        subject: "Alerta de actualización de clave"
    ) do |format|
        format.text { render plain: "Se notifica al usuario que la contraseña de su casillero ha sido actualizada a #{@new_password}" }
    end
    end
end
