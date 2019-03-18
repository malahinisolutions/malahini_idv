class AddDefaultAdminAccount < ActiveRecord::Migration
  def self.up
    AdminAccount.create(email: "admin_user@atencoin.com", password: "PaSSword")
  end

  def self.down
    AdminAccount.find_by_email("admin_user@atencoin.com").destroy
  end
end
