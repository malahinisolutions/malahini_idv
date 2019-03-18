class AddActiveToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :active, :boolean, :default => true
  end
end
