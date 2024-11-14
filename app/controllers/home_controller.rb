class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @available_lockers = Locker.where(password: nil) # Lockers sin password
    @lockers = Locker.all
    @esp32_logs = Esp32Log.all()

    if @user.locker
      @esp32_logs = Esp32Log.all()
    else
      if @user.super_user_mode?
        puts("HOLA")
      else
      @esp32_logs = [] # Si el usuario no tiene locker asignado
      end
    end
  end
# Método para actualizar la contraseña usando signos
def update_password_with_signs
  locker = Locker.find_by(id: params[:locker_id])
  signs = params[:signs].values # Obtener los valores de los signos seleccionados como un array
  puts("HOLA")
  
  # Verifica que se hayan seleccionado exactamente 4 signos
  if signs.length == 4
    puts(signs)
    # Convierte los signos seleccionados en una cadena de texto (un número de 4 dígitos)
    new_password = signs.map { |sign_id| sign_id.to_s }.join
    puts(new_password)
    
    # Verifica que la contraseña tenga 4 dígitos
    if new_password.to_i.to_s.length == 4 # Se asegura de que sea un número de 4 dígitos
      locker.update(password: new_password, updated: true)
      flash[:notice] = "Contraseña actualizada correctamente"
      
      # Llamada para enviar los lockers al broker MQTT
      send_lockers_to_mqtt(locker.id)
    else
      flash[:alert] = "La contraseña debe tener 4 dígitos"
    end
  else
    flash[:alert] = "Debe seleccionar exactamente 4 signos."
  end
  redirect_to root_path
end


  # Asignar un locker a un usuario
  def assign_locker
    locker = Locker.find(params[:locker_id])
    current_user.update(locker: locker)

    flash[:notice] = "Locker asignado correctamente"
    redirect_to root_path
  end

  # Actualizar la contraseña del locker
  def update_password
    locker = Locker.find_by(id: params[:locker_id])
    new_password = params[:new_password]

    if new_password.to_s.length == 4 # Verifica que tenga 4 dígitos
      locker.update(password: new_password, updated: true)
      flash[:notice] = "Contraseña actualizada correctamente"
      
      # Llamada para enviar los lockers al broker MQTT
      send_lockers_to_mqtt(locker.id)
    else
      flash[:alert] = "La contraseña debe tener 4 dígitos"
    end
    redirect_to root_path
  end
  def update_locker
    locker = Locker.find(params[:locker_id])
  
    # Si no se recibe un user_id, buscar el usuario actual con este locker_id y desvincularlo
    if params[:user_id].present?
      user = User.find(params[:user_id])
  
      # Buscar al usuario que tiene este locker asignado y desvincularlo
      existing_user = User.find_by(locker_id: locker.id)
      if existing_user
        # Desvincular el locker del usuario actual
        existing_user.update(locker_id: nil)
      end
  
      # Asignar el locker al nuevo usuario
      user.update(locker_id: locker.id)
  
      flash[:notice] = "Casillero actualizado correctamente con el nuevo usuario"
    else
      # Si no se recibe user_id, solo desvincular el locker del usuario actual
      existing_user = User.find_by(locker_id: locker.id)
      if existing_user
        # Desvincular el locker del usuario actual
        existing_user.update(locker_id: nil)
        flash[:notice] = "Casillero liberado correctamente"
      else
        flash[:alert] = "No hay usuario vinculado a este casillero"
      end
    end
  
    redirect_to root_path
  end
  

  def send_lockers_to_mqtt(updated_locker_id)
    lockers_data = Locker.all.each_with_object({}) do |locker, hash|
      hash[locker.id] = locker.password
    end
    
    lockers_data[5] = updated_locker_id

    mensaje = lockers_data.to_json

    topic = 'passwords'
    MQTT_CLIENT.publish(topic, mensaje, retained: true)

    puts "Datos de lockers enviados al broker MQTT: #{mensaje}"
  end
end
