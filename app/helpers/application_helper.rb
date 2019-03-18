module ApplicationHelper

  # IDCHEKER_TYPE = "idchecker"
  IDCHEKER_TYPE = "authenticid"

  def current_path
    request.env['PATH_INFO']
  end

  def current_user
    current_account
  end

  def active_class( path )
    current_path == path ? "active" : ""
  end

  def verification_tag(type, path, html_class)

    # method  = type == :identify_verified? ? :get : :post

    verified_icon = content_tag(:i, '', class: "fa fa-check fa-lg verify-check")
    identify_verifications = Verification.where(account: current_account)

    unverified_label =
      if identify_verifications.any? && identify_verifications.last.status == "pending"
        content_tag(:span, 'Pending', style: "float: right;margin-top: 2px;", class: "label label-primary")
      else
        link_to "Verify Now", path, method: :get, class: "#{html_class} btn btn-warning btn-xs"
      end

    #current_account.send(type) ? verified_icon : unverified_label
    current_account.verified? ? verified_icon : unverified_label
  end


  def iamreal_tag(path)
    verified_icon = content_tag(:i, '', class: "fa fa-check fa-lg verify-check")

    iamreal_verifications = Verification.where(account: current_account, verification_type: "iamreal")
    #Rails.logger.info(iamreal_verifications.inspect)
    unverified_label =
      if iamreal_verifications.any? && iamreal_verifications.last.status == "pending"
        content_tag(:span, 'Pending', style: "margin-top: 2px;", class: "label label-primary")
      else
        link_to "Verify Now", '#', class: "verify btn btn-warning btn-xs"
      end

    current_account.iamreal_verified? ? verified_icon : unverified_label
  end

  def verify_tag(path)
    verified_icon = content_tag(:i, '', class: "fa fa-check fa-lg verify-check")
    iamreal_verifications = Verification.where(account: current_account, verification_type: "iamreal")
    unverified_label =
    if iamreal_verifications.any? && iamreal_verifications.last.status == "cancelled"
      content_tag(:p, 'Status: Verification Declined, Please try again.', style: "margin-top: 2px;color: red;font-weight: bold;", class: "")
    end

    current_account.iamreal_verified? ? verified_icon : unverified_label
  end


  def admin_panel_item(path, label, resource=nil)
    model_name = resource.nil? ? label.singularize.constantize : resource

    if can? :read, model_name
      link_to label, path
    end

  end

end
