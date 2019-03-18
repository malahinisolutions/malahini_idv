class ChangeBacksideCountries < ActiveRecord::Migration
  def self.up
    Country.select_with_backside_doc
  end

  def self.down
    Country.find_each{ |c| c.update_attributes!(backside_document: false) }
  end
end
