class AddDefaultStates < ActiveRecord::Migration
  def self.up
    # states only for USA in this migrations
    usa_cities = Country.find_by_code("USA").cities
    usa_cities.map(&:District).uniq.each do | state |
      State.create(name: state, country_code: "USA")
    end
  end

  def self.down
    State.where( country_code: "USA" ).map(&:destroy)  
  end
end
