class Staff::MessagesController < Staff::Base

  def index
    @messages = Message.not_deleted.sorted.page(params[:page])
  end

  def inbound #顧客からのメッセージ
    @messages = CustomerMessage.not_deleted.sorted.page(params[:page])
    render :index
  end

  def outbound #返信
    @messages = StaffMessage.not_deleted.sorted.page(params[:page])
    render :index
  end

  def deleted
    @messages = Message.deleted.sorted.page(params[:page])
    render :index
  end

  def destroy
    message = CustomerMessage.find(params[:id])
    message.update_column(:deleted, true)
    flash[:notice] = "問い合わせを削除しました"
    redirect_back(fallback_location: staff_root_path)
  end

  def show
    @message = Message.find(params[:id])
  end



end
