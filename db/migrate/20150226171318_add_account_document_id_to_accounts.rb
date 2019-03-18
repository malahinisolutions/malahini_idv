class AddAccountDocumentIdToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :account_document_id, :integer
  end
end
