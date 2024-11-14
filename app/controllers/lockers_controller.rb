class LockersController < ApplicationController
    before_action :authenticate_user!
    before_action :check_super_user, only: [:change_password, :unlink_user, :force_assign]
  
    def change_password
      # Lógica para cambiar la contraseña
    end
  
    def unlink_user
      locker = Locker.find(params[:id])
      locker.update(user_id: nil)
      redirect_to super_user_mode_path, notice: 'User unlinked from locker.'
    end
  
    def force_assign
      locker = Locker.find(params[:id])
      user = User.find(params[:user_id])
      locker.update(user_id: user.id)
      redirect_to super_user_mode_path, notice: 'Locker assigned to user.'
    end
  
    private
  
    def check_super_user
      redirect_to root_path unless current_user.super_user_mode?
    end
  end
  