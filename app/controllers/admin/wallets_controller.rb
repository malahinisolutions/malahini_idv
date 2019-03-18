class Admin::WalletsController < Admin::AdminController
  active_scaffold :wallet do |config|
    config.actions = [:list, :delete, :show,:search]
    config.columns << :aten_id
    config.columns[:aten_id].label = "Aten Id"
    config.list.columns = [:aten_id, :account, :created_at, :updated_at]
    config.show.columns = [:aten_id, :account, :created_at, :updated_at]

    config.search.columns << :aten_id

    config.columns[:aten_id].search_sql = "accounts.aten_id"
    config.columns[:aten_id].includes = :account
  end
end