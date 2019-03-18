class Admin::ServerPubkeysController < Admin::AdminController
  active_scaffold :server_pubkey do |config|
    config.actions = [:list, :create, :delete, :update, :show,:search, :nested]

    config.columns = [:id, :key, :created_at, :expiration_date]

    config.list.columns = [ :key, :created_at, :expiration_date]

    config.create.columns = [:key, :expiration_date]
    
    config.update.columns = [:key, :expiration_date]

    config.show.columns = [:key, :created_at, :expiration_date ]

    config.columns[:expiration_date].form_ui = :date_select

    config.columns[:key].list_ui = :text
    config.columns[:key].options = { truncate: 30}

  end
end