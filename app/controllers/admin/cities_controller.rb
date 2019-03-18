class Admin::CitiesController < Admin::AdminController
  active_scaffold :city do |config|
    config.columns = [:ID, :CountryCode, :Name, :District, :Population]
  end
end