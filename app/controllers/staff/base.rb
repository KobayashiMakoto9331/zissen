class Staff::Base < ApplicationController
  before_action :check_source_ip_address
  before_action :authorize
  before_action :check_account
  before_action :check_timeout
    TIMEOUT = 60.minutes

  helper_method :current_staff_member

  private

  def check_source_ip_address
    raise IpAddressRejected unless AllowedSource.include?("staff", request.ip)
  end

  def authorize
    unless current_staff_member
      flash[:alert] = "職員としてログインしてください"
      redirect_to staff_login_path
    end
  end

  def current_staff_member
    @current_staff_member ||= StaffMember.find_by(id: session[:staff_member_id]) if session[:staff_member_id]
  end

  def check_account
    if current_staff_member && !current_staff_member.active?
      session.delete(:staff_member_id)
      flash[:alert] = "アカウントが無効になりました"
      redirect_to staff_root_path
    end
  end

  def check_timeout
    if current_staff_member
      if session[:last_access_time] >= TIMEOUT.ago
        session[:last_access_time] = Time.current
      else
        session.delete(:staff_member_id)
        flash[:alert] = "セッションがタイムアウトしました"
        redirect_to staff_login_path
      end
    end
  end
end