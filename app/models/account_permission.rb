class AccountPermission < ActiveRecord::Base
  belongs_to :account

  %w{ cities countries states }.each do |location|
    define_method("manage_#{location}") do
      manage_locations
    end
  end

  def get_resources_by_action(action)
    arr = []
    resources.select{|k, v| k.include?(action.to_s) && v == true}.keys.each do |r| 
      if r =~ /locations/
        arr << [City, State, Country] 
      else
        arr << r.sub(/.*?_/, '').singularize.capitalize.constantize
      end
    end

    arr
  end

  def resources
    serializable_hash.except("id", "account_id", "account_role")
  end

  def to_label
    "#{account.email} abilities"
  end

  def manage_wallets
    false
  end
end
