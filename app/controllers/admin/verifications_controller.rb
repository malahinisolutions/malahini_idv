class Admin::VerificationsController < Admin::AdminController

  active_scaffold :verification do |config|
    config.actions = [:list, :create, :delete, :update, :show,:search]

    config.list.columns = [:id, :account_id, :account, :verification_type, :status, :cancel_reason, :created_at]

    config.create.columns = [:account, :verification_type, :status, :cancel_reason ]

    config.update.columns = [:account, :verification_type, :status, :cancel_reason]
  end
  
end