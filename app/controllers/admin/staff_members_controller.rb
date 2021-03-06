class Admin::StaffMembersController < Admin::Base

  def index
    @staff_members = StaffMember.order(:family_name_kana, :given_name_kana).page(params[:page])
  end

  def show
    staff_member = StaffMember.find(params[:id])
    redirect_to edit_admin_staff_member_path(staff_member)
  end

  def new
    @staff_member = StaffMember.new
  end

  def create
    @staff_member = StaffMember.new(staff_member_params)
    if @staff_member.save
      flash[:notice] = "職員アカウントを登録しました"
      redirect_to admin_staff_members_path
    else
      render :new
    end
  end

  def edit
    @staff_member = StaffMember.find(params[:id])
  end

  def update
    @staff_member = StaffMember.find(params[:id])

    if @staff_member.update(staff_member_params)
      flash[:notice] = "職員アカウントを更新しました"
      redirect_to admin_staff_members_path
    else
      render :edit
    end
  end

  def destroy
    staff_member = StaffMember.find(params[:id])
    staff_member.destroy!
    flash[:notce] = "職員アカウントを削除しました"
    redirect_to admin_staff_members_path
  end

  private

  def staff_member_params
    params.require(:staff_member).permit(
      :email, :password, :family_name, :given_name,
      :family_name_kana, :given_name_kana,
      :start_date, :end_date, :suspended
    )
  end

end
