class Staff::Base < ApplicationController
  helper_method :current_staff_member

  private

  def current_staff_member
    current_staff_member ||= StaffMember.find_by(id: session[:staff_member_id]) if session[:staff_member_id]
  end
end