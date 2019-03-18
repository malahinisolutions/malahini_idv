class Admin::AdminController < ApplicationController
  before_filter :authenticate_admin_account!
  layout "admin_application"
end