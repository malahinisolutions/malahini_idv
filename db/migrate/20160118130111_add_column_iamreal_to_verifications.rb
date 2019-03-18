class AddColumnIamrealToVerifications < ActiveRecord::Migration
  def self.up
    change_column :verifications, :verification_type, "enum('idchecker', 'directid', 'netverify', 'authenticid', 'iamreal')"
  end

  def self.down
  end
end
