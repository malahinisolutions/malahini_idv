class ChangeColumnVerificationType < ActiveRecord::Migration
  def change
    change_column :verifications, :verification_type, "enum('idchecker', 'directid', 'netverify')"
  end
end
