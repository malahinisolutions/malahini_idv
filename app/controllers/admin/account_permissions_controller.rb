class Admin::AccountPermissionsController < Admin::AdminController
  active_scaffold :account_permission do |config|

    config.actions = [:list, :create, :delete, :update, :show,:search]


    config.list.columns = [
                            :account,
                            :account_role,
                            :read_accounts,
                            :manage_accounts,
                            :read_wallets,
                            :read_verifications,
                            :manage_verifications,
                            :read_locations,
                            :manage_locations 
                          ]

    config.update.columns = [
                              :read_accounts,
                              :manage_accounts,
                              :read_wallets,
                              :read_verifications,
                              :manage_verifications,
                              :read_locations,
                              :manage_locations 
                            ]

                            

  end 
end