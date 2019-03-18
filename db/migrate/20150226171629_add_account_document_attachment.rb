class AddAccountDocumentAttachment < ActiveRecord::Migration
  def self.up
    add_attachment :account_documents, :account_document
  end

  def self.down
    remove_attachment :account_documents, :account_document
  end
end
