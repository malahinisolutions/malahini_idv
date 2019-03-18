class AddBacksideDocumentToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :backside_document, :boolean, default: false
  end
end
