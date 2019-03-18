class IdChecker::Main

  SYSTEM_TYPE = "authenticid"
  PENDING_STATUS = "pending"
  ID_CHECKER_PATH = "api/initiate_merchant_session"
  ALGORITHM = 'AES-256-CBC'
  BACK_SIDE_EROR_MSG = "Back side of the document for this country can't be blank."

  include ActiveModel::Validations
  extend EncryptFactory

  validates :live_photo_1, :live_photo_2, presence: true # :account_document_1,
  # validate :check_document_backside

  attr_accessor :account_document_1, :account_document_2, :live_photo_1,
                :live_photo_2, :country


  def initialize(params)
    params.each do |key, value|
      instance_variable_set("@#{key}".to_sym, value)
    end
  end

  def self.send_data( account_opts, url, identify_type, photos )
    account_opts.select! { |_k, v| v.present? }
    encrypted_data = encode_params(account_opts)
    signature =  Digest::MD5.hexdigest( account_opts.keys.sort.map { |key| account_opts[key].to_s }.inject(:+) + SERVER_X_KEY )


    opts = {     "cmd" => identify_type,
                "data" => encrypted_data.gsub("\n", ""),
              # "photos" => photos,
                "sign" => signature
          }
    
    begin
      #Rails.logger.info(url.inspect)  
      post = CustomSender.new( url ).post_data( opts )
      #Rails.logger.info("RESPONSE: " + post.inspect)
      # raise JSON.parse(post).inspect
      JSON.parse(post)
    rescue StandardError => e
      { result: "error" }
    end

  end

  def skip_photos?
    documents_blank? && all_photos_present?
  end

  def photos_to_json
    photos = {
       # "image_data_1" => self.class.encode_params(data_image(account_document_1), to_query: false),
       "live_photo_1" => self.class.encode_params(process_live_photo(live_photo_1), to_query: false),
       "live_photo_2" => self.class.encode_params(process_live_photo(live_photo_2), to_query: false) 
     }

    if account_document_2.nil? 
      photos.to_json
    else
      photos.merge({"image_data_2" => self.class.encode_params(data_image(account_document_2), to_query: false) }).to_json
    end   
  end

  def process_live_photo(file_name)
    if file_name
      path = Rails.root.join("headshots", file_name)
      encoded_str = Base64.encode64(File.open(path, "rb") {|file| file.read}).gsub("\n", "")
    else
      nil
    end
  end

  def data_image(image)
    Base64.encode64(File.read(image.tempfile)).gsub("\n", '')
  end

  def authenticate_id_url
    config = YAML.load_file("config/configs.yml")[Rails.env].deep_symbolize_keys!
    config[:authenticate_id][:url]
  end

  private

  def self.encode_params(params, to_query: true)
    Base64.encode64(AESCrypt.encrypt_data((to_query ? params.to_query : params), SERVER_X_KEY, SERVER_X_IV, ALGORITHM)).gsub("\n", "")
  end


  def all_photos_present?
    !live_photo_1.blank? && !live_photo_2.blank?
  end

  def documents_blank?
    account_document_1.nil? || (account_document_2.nil? && backside_document_need?)
  end

  def backside_document_need?
    countries = Country.with_backside_document.pluck(:code)
    countries.include?(country)
  end

  def check_document_backside
    # checking backside and frontside document scans
    self.errors.add(:base, BACK_SIDE_EROR_MSG) if backside_document_need? && account_document_2.blank?
  end

  
end
