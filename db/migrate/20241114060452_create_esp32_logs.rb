class CreateEsp32Logs < ActiveRecord::Migration[7.1]
  def change
    create_table :esp32_logs do |t|
      t.string :message
      t.datetime :received_at

      t.timestamps
    end
  end
end
