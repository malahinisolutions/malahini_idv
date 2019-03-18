class Admin::CountriesController < Admin::AdminController
  active_scaffold :country do |config|
    config.columns = [:Code, :Name, :Region, :Population, :LocalName, :active, :backside_document]
  end
end