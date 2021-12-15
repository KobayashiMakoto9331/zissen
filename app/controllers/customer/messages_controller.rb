class Customer::MessagesController < Customer::Base

  def new
    @message = CustomerMessage.new
  end

  def confirm
    @message = CustomerMessage.new(customer_message_params)
    @message.customer = current_customer
    if @message.valid?
      render :confirm
    else
      flash.now[:alert] = "入力に誤りがあります"
      render :new
    end
  end

  def create
    @message = CustomerMessage.new(customer_message_params)
    if params[:commit]
      @message.customer = current_customer
      if @message.save
        flash[:notice] = "問い合わせを送信しました"
        redirect_to customer_root_path
      else
        flash.now[:alert] = "入力に誤りがあります"
        render :new
      end
    else
      render :new
    end
  end

  private

  def customer_message_params
    params.require(:customer_message).permit(:subject, :body)
  end
end
