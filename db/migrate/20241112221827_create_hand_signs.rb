class CreateHandSigns < ActiveRecord::Migration[7.1]
  def change
    create_table :hand_signs do |t|
      t.string :name
      t.string :image_link

      t.timestamps
    end
  end
end
