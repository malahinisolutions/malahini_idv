class Account < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable

  has_many :api_accounts
  validates :login, uniqueness: true

  # SECRET_KEY => /config/initializers/secret_key.rb
  attr_encrypted :password, :key => SECRET_KEY, :encode => true, :charset => "utf-8", algorithm: "aes-256-ecb"


  def to_label
    "Account for #{login}"
  end

end
