class Admin::Base < ApplicationController
  helper_method :current_administrator

  private
  def current_administrator
    @current_administrator ||= Administrator.find_by(id: session[:administrator_id]) if session[:administrator_id]
  end
end