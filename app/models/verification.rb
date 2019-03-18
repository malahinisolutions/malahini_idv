class Verification < ActiveRecord::Base
  belongs_to :account

  scope :processed,   ->{ where( status: "processed" ) }
  scope :financial,   ->{ where( verification_type: "directid" ) }
  scope :authenticid, ->{ where( verification_type: "authenticid" ) }
  scope :identify,    ->{ where( verification_type: ["authenticid", "netverify"]) }
  scope :iamreal,     ->{ where(verification_type: "iamreal") }

  after_save :removing_temporality

  def to_label
    account.present? ? "verification for #{account.email}" : "verification #{id}"
  end

  protected

  def removing_temporality
    if status == "processed"
      account.update_attributes({temporary: false})
    end
  end

end
