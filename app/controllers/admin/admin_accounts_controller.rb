class Admin::AdminAccountsController < Admin::AdminController
  active_scaffold :admin_account do |config|
    config.list.columns = [ :email,  :created_at]
    config.create.columns = [ :email, :password ]
  end
end