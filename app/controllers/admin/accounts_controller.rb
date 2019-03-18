class Admin::AccountsController < Admin::AdminController
  active_scaffold :account do |config|

    config.actions = [:list, :create, :delete, :update, :show,:search]

    config.columns = [:id, :email, :aten_id, :login, :active, :created_at, :password, :password_confirmation]
    config.list.columns = [:id, :aten_id, :email, :login, :account_type, :active, :created_at]

    config.create.columns = [:email, :login, :password, :password_confirmation]

    config.columns[:aten_id].label = "Aten Id"
    
    config.columns[:password].form_ui = :password
    config.columns[:password_confirmation].form_ui = :password
    # config.list.columns = [:id, :first_name, :last_name, :mid_initials, :email, :phone, :address, :active, :created_at]

    config.show.columns = [:id, :aten_id, :email, :login, :active, :created_at]

    
    config.update.columns = [:login, :email, :password, :account_type, :active]

    # config.show.columns = [:login, :encryped_password, :email, :first_name, :last_name, :active, :phone_number, :created_at ]

  end

  protected

  def before_create_save(record)
    record.confirmed_at = Time.now
  end

end