# Account personal data ; model needs only for validation the user's data
class AccountPersonalInformation
  include ActiveModel::Validations

  attr_accessor :first_name, :last_name, :date_of_birth, 
                :nationality, :country_id, :city_id, :state_id, :zip, :home_address, :mailing_address #middle_initials

  validates_presence_of :first_name, :last_name, :date_of_birth, 
                        :nationality, :country_id, :city_id, :zip, :home_address

  def initialize(params)
    params.each do | key, value |
      var_name = "@#{key}"
      self.instance_variable_set(var_name, value)
    end
  end
end
