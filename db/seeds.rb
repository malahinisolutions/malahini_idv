# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

## Add auth_token to all users
# Account.where(:gauth_secret => nil).find_each do |user|
#   user.send(:assign_auth_secret)
#   user.save!
# end

## Add aten_id to all users

#Account.where(aten_id: nil).find_each do |account|
#  account.set_aten_id
#  account.save!
#end
#Verifier.create!([{
#  first_name: "Aten",
#  last_name: "Tech Support",
#  email: "support@atenwallet.com",
#  encrypted_password: "$2a$10$PzdIkNqYrrpb9f3MAGjC6.DCxVTIo3k9ACgEZPFC7toOZq5LBTsmS"
#}])
 
#p "Created #{Verifier.count}  record"
#UserVerification.delete_all
#p "Created #{UserVerification.count}  record"