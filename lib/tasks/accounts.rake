LAST_VALID_COUNT_OF_DAYS = 1
DAY = "2 Sep 2015" 

namespace :accounts do 

  task delete_temporary_accounts: :environment do 
    first_day_removal_accs = Time.parse(DAY)
    Account.temporary_accounts.find_each{ | acc | acc.destroy if acc.days_remaining_without_verification < LAST_VALID_COUNT_OF_DAYS && 
                                                                 acc.created_at > first_day_removal_accs }
  end

  task delete_wallet_passwords: :environment do 
    Wallet.where.not(password: nil).to_a.each do |wallet| 
      wallet.password = nil
      wallet.save(validate: false)
    end 
  end

  task delete_unused_passwords: :environment do 
    AccountConfirmationCredential.clean_up_credentials
  end

  task delete_unuse_aten_credentials: :environment do
    WalletConfirmationCredential.clean_up_credentials
  end

end
