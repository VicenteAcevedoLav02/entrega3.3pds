Rails.application.routes.draw do
  devise_for :users, controllers: {
  omniauth_callbacks: 'users/omniauth_callbacks'
}
  post 'publish_mqtt', to: 'home#publish_message'
  post 'assign_locker', to: 'home#assign_locker'
  post 'update_password', to: 'home#update_password'
  post 'update_locker', to: 'home#update_locker'
  post 'update_password_with_signs', to: 'home#update_password_with_signs' # Nueva

  resources :lockers do
    member do
      get 'change_password'
      post 'unlink_user'
      post 'force_assign'
    end

  end

  
  root 'home#index'
end
# config/routes.rb


