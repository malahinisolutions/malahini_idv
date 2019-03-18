class ChangeAccountTypeColumn < ActiveRecord::Migration
  def change
    change_column :accounts, :account_type, "enum('admin', 'manager', 'user')", default: "user"
  end
end
