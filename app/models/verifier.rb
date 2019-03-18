class Verifier < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable,:recoverable, :rememberable, :trackable, :validatable and :omniauthable
  devise :database_authenticatable, :timeoutable
end
