class Admin::Base < ApplicationController
  helper_method :current_administrator

  private
  def current_administrator
    @current_administrator ||= Adnministrator.find_by(id: session[administrator_id]) if administrator_id
  end
end