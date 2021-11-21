class Admin::Base < ApplicationController
  before_action :check_source_ip_address
  before_action :authorize
  before_action :check_account
  before_action :check_timeout
    TIMEOUT = 60.minutes

  helper_method :current_administrator

  private

  def check_source_ip_address
    raise IpAddressRejected unless AllowedSource.include?("admin", request.ip)
  end

  def authorize
    unless current_administrator
      flash[:alert] = "管理者としてログインしてください"
      redirect_to admin_login_path
    end
  end

  def current_administrator
    @current_administrator ||= Administrator.find_by(id: session[:administrator_id]) if session[:administrator_id]
  end

  def check_account
    if current_administrator && current_administrator.suspended?
      session.delete(:administrator_id)
      flash[:alert] = "アカウントが無効になりました"
      redirect_to admin_root_path
    end
  end

  def check_timeout
    if current_administrator
      if session[:admin_last_access_time] >= TIMEOUT.ago
        session[:admin_last_access_time] = Time.current
      else
        session.delete(:administrator_id)
        flash[:alert] = "アカウントが無効になりました"
        redirect_to admin_login_path
      end
    end
  end
end