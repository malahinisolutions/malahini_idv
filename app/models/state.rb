class State < ActiveRecord::Base
  has_many :accounts
  belongs_to :country, foreign_key: "Code"
  # alias_method :country_id, :countryID

end