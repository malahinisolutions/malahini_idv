module AdminHelper
  
  def server_pubkey_expiration_date_form_column(record, options)
    datetime_select("record", "expiration_date")
  end

end