module AdminHelper
  def verification_status_form_column( record, options)
    status = record.status ? record.status : ""
    select_tag "record[status]", options_for_select( [ "", "pending", "processed", "cancelled"], selected: status )
  end

  def verification_type_form_column( record, options)
    type = record.verification_type ? record.verification_type : ""
    select_tag "record[verification_type]", options_for_select( [ "", "authenticid", "directid"], selected: type )
  end

  def verification_account_column(record, options)
    record.account ? record.account.to_label : ""
  end

  def wallet_account_column(record, options)
    record.account ? record.account.to_label : ""
  end

  def account_account_type_form_column(record, options)
    select_tag "record[account_type]", options_for_select( Account::ACCOUNT_TYPES, selected: record.account_type )
  end

  def wallet_aten_id_column(record, options)
    record.account ? record.account.aten_id : nil 
  end

   def display_action_links(action_links, record, options, &block)
    options[:level_0_tag] ||= nil
    options[:options_level_0_tag] ||= nil
    options[:level] ||= 0
    options[:first_action] = true
    output = ActiveSupport::SafeBuffer.new
    staff_manage_actions = ["new", "edit", "destroy"]
    res = params[:controller].split("/").last
    acc_is_staff = Account::ACCOUNT_ABILITY_TYPES.include?(current_account.account_type)
    ability = current_account.account_permission

    action_links.each(:reverse => options.delete(:reverse), :groups => true) do |link|

      next if staff_manage_actions.include?(link.action) && (acc_is_staff && ability.send("manage_#{res}") == false)

      if link.is_a? ActiveScaffold::DataStructures::ActionLinks
        unless link.empty?
          options[:level] += 1
          content = display_action_links(link, record, options, &block)
          options[:level] -= 1
          if content.present?
            output << display_action_link(link, content, record, options)
            options[:first_action] = false
          end
        end
      elsif !skip_action_link?(link, *Array(options[:for]))
        authorized = action_link_authorized?(link, *Array(options[:for]))
        next if !authorized && options[:skip_unauthorized]
        output << display_action_link(link, nil, record, options.merge(:authorized => authorized))
        options[:first_action] = false
      end
    end
    output
  end

end