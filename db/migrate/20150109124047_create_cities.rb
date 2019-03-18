class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.string :abbreviation
      t.integer :country_id
      t.integer :state_id

    end
  end
end
