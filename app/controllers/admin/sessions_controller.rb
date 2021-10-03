class Admin::SessionsController < Admin::Base
  def new
    @form = Admin::LoginForm
  end

  def create
    @form = Admin::LoginForm.new(params[:admin_login_form])
    administrator = Administrator.find_by("LOWER(email)=?", @form.email.downcase) if @form.email.present?

    if Admin::Authenticator.new(administrator).authenticate(@form.password)

      if administrator.suspended?
        flash[:alert] = "アカウントが停止されています"
        render :new
      else
        session[:administrator_id]= administrator.id
        flash[:notice] = "ログインしました"
        redirect_to admin_root_path
      end

    else
      flash.now[:alert] = "メールアドバイスまたはパスワードが間違っています"
      render :new
    end
  end

  def destroy
    session.delete(:administrator_id)
    flash[:notice] = "ログアウトしました"
    redirect_to admin_root_path
  end

end
