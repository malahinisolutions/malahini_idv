class Account < ActiveRecord::Base

  UNDEFINED_CITY = "Undefined city"
  COUNTRY_ABBREVIATION_FOR_PESSEL_NUMBER = "POL"
  ACCOUNT_TYPES = %w{ admin manager user }
  ACCOUNT_ABILITY_TYPES = %w{ manager }

  FIRST_ACC_ID_CHAR = "A"
  ACC_ID_SIZE = 9
  WHITESPACE_ACC_ID_CHAR = "0"

  # has_attached_file :account_document, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  # validates_attachment_content_type :account_document, :content_type => /\Aimage\/.*\Z/

  has_many :verifications,                    dependent: :destroy
  has_one  :wallet,                           dependent: :destroy
  has_one  :account_permission,               dependent: :destroy
  has_many :headshot_photos,                  dependent: :destroy
  has_many :account_confirmation_credentials, dependent: :destroy 
  has_many :wallet_confirmation_credentials,  dependent: :destroy
  has_many :user_verifications,               dependent: :destroy

  belongs_to :country
  belongs_to :state
  belongs_to :city

  scope :temporary_accounts, -> { where(temporary: true) }

  validates_presence_of :login, :email

  after_save   :create_manager_abilities

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :authy_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  def to_label
    "#{login}"
  end
  
  def verified?
    verifications.processed.any?
  end
  
  def identify_verified?
    verifications.identify.processed.any?
  end

  def financial_verified?
    verifications.financial.processed.any?
  end

  def iamreal_verified?
    verifications.iamreal.processed.any?
  end

  def completely_verified?
    identify_verified? || financial_verified? || iamreal_verified?
  end

  def admin?
    account_type == "admin"
  end

  def manager?
    account_type == "manager"
  end

  def is_staff?
    admin? || manager?
  end

  def verify( verification )
    verifications << verification 
  end

  def banned?
    !active?
  end

  def to_hash(login, password)
    { id: id, aten_id: aten_id, login: login, password: password, email: email, 
      created_at: wallet.created_at.to_i, updated_at: wallet.updated_at.to_i 
    }
  end

  def active_for_authentication?
    super && !self.banned?
  end

  def days_remaining_without_verification
    days = (TEMP_USER_DAYS_COUNT - (Time.now.utc - created_at.utc).to_i/(24*60*60).to_f).round
    days < 0 ? 0 : days
  end

  def generate_pasword_confirmation_token
    String.generate_string
  end

  def set_aten_id
    hexdecimal_acc_id = id.to_s(16).upcase 
    string_pattern = "#{FIRST_ACC_ID_CHAR}%s#{hexdecimal_acc_id}"
    
    self.aten_id = string_pattern % ( WHITESPACE_ACC_ID_CHAR * (ACC_ID_SIZE - FIRST_ACC_ID_CHAR.size - hexdecimal_acc_id.size) ) 
    aten_id
  end

  protected

  def create_manager_abilities
    create_ability if ACCOUNT_ABILITY_TYPES.include?(account_type)
  end

  def create_ability
    AccountPermission.create(account: self, account_role: account_type) if account_permission.nil?
  end

  def check_pessel_number
    if country_id == COUNTRY_ABBREVIATION_FOR_PESSEL_NUMBER
      self.errors.add(:base, "Pesel number can't be blank for this country") if pesel_number.empty?
    else
      self.pesel_number = nil
    end
  end

  def set_city
    city = City.find_by_name(city_id)
    self.city_id = city.id
  end

  def check_city
    self.errors.add(:base, UNDEFINED_CITY) if self.new_record? && city_id && City.find_by_name(city_id).nil?
  end

end
