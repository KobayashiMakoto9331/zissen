class Admin::AllowedSourcesController < Admin::Base

  def index
    @allowed_sources = AllowedSource.where(namespace: "staff")
      .order(:octet1, :octet2, :octet3, :octet4)
    @new_allowed_source = AllowedSource.new
  end

  def create
    @new_allowed_source = AllowedSource.new(allowed_source_params)
    @new_allowed_source.namespace = "staff"

    if @new_allowed_source.save
      flash[:notice] = "許可IPアドレスを追加しました"
      redirect_to admin_allowed_sources_path
    else
      @allowed_sources = AllowedSource.order(:octet1, :octet2, :octet3, :octet4)
      flash.now[:alert] = "許可IPアドレスは正しくありません"
      render :index
    end
  end

  def delete
    if Admin::AllowedSourcesDeleter.new.delete(params[:form])
      flash[:notice]="許可IPアドレスを削除しました。"
    end
      redirect_to admin_allowed_sources_path
  end

  private

  def allowed_source_params
    params.require(:allowed_source).permit(:octet1, :octet2, :octet3, :last_octet)
  end

end
