class Staff::AccountsController < Staff::Base

  def show
    @staff_member = current_staff_member
  end

  def edit
    @staff_member = current_staff_member
  end

  def update
    staff_member = current_staff_member
    if staff_member.update(staff_member_params)
      flash[:notice] = "アカウント情報を更新しました"
      redirect_to staff_account_path
    else
      render :edit
    end
  end

  private
  def staff_member_params
    params.require(:staff_member).permit(
      :email, :family_name, :given_name,
      :family_name_kana, :given_name_kana
    )
  end

end
