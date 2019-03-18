class City < ActiveRecord::Base

  alias_attribute :country_code, :CountryCode
  alias_attribute :name, :Name

  has_many :accounts, foreign_key: "city_id"
  belongs_to :country, foreign_key: "Code"
end