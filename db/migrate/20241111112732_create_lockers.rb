class CreateLockers < ActiveRecord::Migration[7.1]
  def change
    create_table :lockers do |t|
      t.integer :password, limit: 4, null: true # Limita el valor a un número de 4 dígitos
      t.boolean :updated, default: false
      t.timestamps
    end
  end
end
