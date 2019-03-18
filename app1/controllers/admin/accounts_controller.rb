class Admin::AccountsController < Admin::AdminController
  active_scaffold :account do |config|

    config.actions = [:list, :create, :delete, :update, :show,:search, :nested]

    config.columns = [:id, :login, :encryped_password, :created_at, :api_account]

    config.list.columns = [ :login, :encrypted_password, :email, :first_name, :last_name, :active, :phone_number, :created_at]

    config.create.columns = [:login, :password, :email, :first_name, :last_name, :active, :phone_number]
    
    config.update.columns = [:login, :email, :first_name, :last_name, :active, :phone_number]

    config.show.columns = [:login, :encryped_password, :email, :first_name, :last_name, :active, :phone_number, :created_at ]

  end
end