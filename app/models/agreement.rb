class Agreement
  include ActiveModel::Validations

  # all agreements ( true or false)
  attr_accessor :terms_of_use, :allow_personal_data, :allow_report_transactions,
                :allow_anonymous_data, :removing_temp_user

  # validates_inclusion_of :terms_of_service, :allow_personal_data, :allow_report_transactions,
  #                        :allow_anonymous_data, :removing_temp_user, :in => ["true"]


  validates_inclusion_of :terms_of_use, :in => ["true"]

  def initialize(params)
    @terms_of_use, @allow_personal_data = params[:terms_of_use], params[:allow_personal_data]
    @removing_temp_user, @allow_anonymous_data = params[:removing_temp_user], params[:allow_anonymous_data]
    @allow_report_transactions = params[:allow_report_transactions]
  end

end