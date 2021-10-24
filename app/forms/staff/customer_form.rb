class Staff::CustomerForm
  include ActiveModel::Model

  attr_accessor :customer
  delegate :persisted?, :save, to: :customer #persistedメソッドをcustomerに移譲、persisted? -> customer.persisted?

  def initialize(customer=nil)
    @customer = customer
    @customer ||= Customer.new(gender: "male")
    @customer.build_home_address unless @customer.home_address #formを表示させるために記述。 has_one 記入で追加されたメソッド
    @customer.build_work_address unless @customer.work_address
  end

  def assign_attributes(params={})
    @params = params

    customer.assign_attributes(customer_params)
    customer.home_address.assign_attributes(home_address_params)
    customer.work_address.assign_attributes(work_address_params)
  end

  private

  def customer_params
    @params.require(:customer).permit(
      :email, :password,
      :family_name, :given_name, :family_name_kana, :given_name_kana,
      :birthday, :gender
    )
  end

  def home_address_params
    @params.required(:home_address).permit(
      :postal_code, :prefecture, :city, :address1, :address2,
    )
  end

  def work_address_params
    @params.required(:work_address).permit(
    :company_name, :division_name,  :postal_code, :prefecture, :city, :address1, :address2,
    )
  end

end