require 'csv' 

class Country < ActiveRecord::Base

  alias_attribute :code, :Code
  alias_attribute :name, :Name

  has_many :states, foreign_key: "country_code"
  has_many :cities, foreign_key: "CountryCode"

  has_many :accounts, foreign_key: "country_id"

  scope :with_backside_document, -> { where(backside_document: true) }


  def self.select_with_backside_doc
    csv_text = File.read('supported_ids_country_settings.csv')
    csv = CSV.parse(csv_text)

    keys = ["Country", "ID card - Allowed", "ID card - Back", "ID card - Minimum year", 
            "Passport - Allowed", "Passport - Minimum year", "Driver license - Allowed", 
            "Driver license - Back", "Driver license - Minimum year"]

    countries = csv.map {|a| Hash[ keys.zip(a) ] }
                   .map{ |row| row["Country"] if row["ID card - Back"] == "Yes" || row["Driver license - Back"] == "Yes"}
                   .compact

    unfound_countries = %w( Moldova Macedonia Venezuela Yugoslavia )

    countries = (countries + unfound_countries).map do | name | 
      c = Country.find_by_name(name)  
      c.update_attributes!(backside_document: true) if c
    end
  end
end