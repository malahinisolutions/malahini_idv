class AgreementsController < ApplicationController
  def terms_of_use
  end

  def disclaimers
  end

  def privacy_police
  end

  def kyc_and_aml
  end

  def check_agreements
    @agreement = Agreement.new( agreement_params )

    if @agreement.valid?
      redirect_to :new_account_registration
    else
     gflash :now, :error => "You should agree with all the agreements."
     render :agreements
    end
  end

  private

  def agreement_params
    params.permit( :terms_of_use, :allow_personal_data, :allow_report_transactions,
                   :allow_anonymous_data, :removing_temp_user )
  end

end
