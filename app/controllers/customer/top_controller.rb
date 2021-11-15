class Customer::TopController < Customer::Base
  skip_before_action :authorize

  def index
  end
  
end
