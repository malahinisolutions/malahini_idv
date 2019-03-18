class Admin::StatesController < Admin::AdminController
  active_scaffold :state do |config|
    config.columns = [:name, :country_code]
  end
end