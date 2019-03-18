class CreateAccountDocuments < ActiveRecord::Migration
  def change
    create_table :account_documents do |t|

      # t.timestamps null: false
    end
  end
end
