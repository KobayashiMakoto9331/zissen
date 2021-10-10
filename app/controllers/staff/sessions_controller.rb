class Staff::SessionsController < Staff::Base
  def new
    if current_staff_member
      redirect_to :staff_root
    else
      @form = Staff::LoginForm.new
      render :new
    end
  end

  def destroy
    session.delete(:staff_member_id)
    flash[:notice] = "ログアウトしました"
    redirect_to staff_root_path
  end

  def create
    @form = Staff::LoginForm.new(login_form_params)
    if @form.email.present?
      staff_member = StaffMember.find_by("LOWER(email) = ?", @form.email.downcase)
    end

    if Staff::Authenticator.new(staff_member).authenticate(@form.password)

      if staff_member.suspended?
        flash.now[:alert] = "アカウントが停止されています"
        render :new
      else
        session[:staff_member_id] = staff_member.id
        flash[:notice] = "ログインしました"
        redirect_to staff_root_path
      end

    else
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません"
      render :new
    end
  end

  private

  def login_form_params
    params.require(:staff_login_form).permit(:email, :password)
  end

end
