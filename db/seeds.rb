# db/seeds.rb

# Crea cuatro lockers con contraseña vacía (password = null)
4.times do
    Locker.create(password: nil, updated: false)
  end
  
  puts "4 lockers creados con password = null"

User.create(
    email: "admin@gmail.com",
    password: "adminmode",
    super_user_mode: true
)
puts "Admin creado"
User.create(
    email: "vicho@gmail.com",
    password: "skibidi",
    super_user_mode: false
)

#ACA EL ÓRDEN DE CREACIÓN DEBE CORRESPONDER A LOS IDS QUE SE USAN PARA CADA IMAGEN!!

# db/seeds.rb

sign_names = ["open", "closed", "thumbup", "rock", "threefingers", "onefinger"]

# Crear cada signo con el nombre y el enlace a su imagen
sign_names.each do |name|
  HandSign.create(
    name: name,
    image_link: "#{name.downcase.gsub(' ', '_')}_icon_final.jpg"
  )
end

puts "Signos creados exitosamente"
