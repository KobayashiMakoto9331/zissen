module ErrrorHandlers
  extend ActiveSpport::Concern

  include do
    rescue_from StandardError, with: :rescue500
    rescue_from ApplicationController::Forbidden, with: :rescue403
    rescue_from ApplicationController::IpAdressRejected, with: :rescue403
    rescue_from ActiveRecord::RecordNotFound, with: :rescue404
  end


  private
  def rescue500(e)
    render "errors/internal_server_error", status: 500
  end

  def rescue403(e)
    @exception = e
    render "errors/forbidden", status: 403
  end

  def rescue404(e)
    render "errors/not_found", status: 404
  end
end