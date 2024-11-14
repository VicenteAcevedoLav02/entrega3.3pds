class AddSuperUserModeAndLockerIdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :super_user_mode, :boolean
    add_column :users, :locker_id, :integer
  end
end
