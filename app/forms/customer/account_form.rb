class Customer::AccountForm
  include ActiveModel::Model

  attr_accessor :customer, :inputs_home_address, :inputs_work_address
  delegate :persisted?, :valid?, :save, to: :customer #persistedメソッドをcustomerに移譲、persisted? -> customer.persisted?

  def initialize(customer)
    @customer = customer

    (2 - @customer.personal_phones.size).times do
      @customer.personal_phones.build
    end

    self.inputs_home_address = @customer.home_address.present?
    self.inputs_work_address = @customer.work_address.present?
    @customer.build_home_address unless @customer.home_address #formを表示させるために記述。 has_one 記入で追加されたメソッド
    @customer.build_work_address unless @customer.work_address

    (2 - @customer.home_address.phones.size).times do
      @customer.home_address.phones.build
    end

    (2 - @customer.work_address.phones.size).times do
      @customer.work_address.phones.build
    end
  end

  def assign_attributes(params={})
    @params = params

    customer.assign_attributes(customer_params)
    phones = phone_params(:customer).fetch(:phones)

    customer.personal_phones.size.times do |index|
      attributes = phones[index.to_s]
      if attributes && attributes[:number].present?
        customer.personal_phones[index].assign_attributes(attributes)
      else
        customer.personal_phones[index].mark_for_destruction
      end
    end

    self.inputs_home_address = params[:inputs_home_address].in? %w(1 true) #チェックがあるとtrueがinputs_work_addressにセットされる
    self.inputs_work_address = params[:inputs_work_address].in? %w(1 true)

    if inputs_home_address
      customer.home_address.assign_attributes(home_address_params)
      phones = phone_params(:home_address).fetch(:phones)

      customer.home_address.phones.size.times do |index|
        attributes = phones[index.to_s]
        if attributes && attributes[:number].present?
          customer.home_address.phones[index].assign_attributes(attributes)
        else
          customer.home_address.phones[index].mark_for_destruction
        end
      end

    else
      customer.home_address.mark_for_destruction
    end

    if inputs_work_address
      customer.work_address.assign_attributes(work_address_params)
      phones = phone_params(:work_address).fetch(:phones)

      customer.work_address.phones.size.times do |index|
        attributes = phones[index.to_s]
        if attributes && attributes[:number].present?
          customer.work_address.phones[index].assign_attributes(attributes)
        else
          customer.work_address.phones[index].mark_for_destruction
        end
      end

    else
      customer.work_address.mark_for_destruction
    end
  end

  private

  def customer_params
    @params.require(:customer).permit(
      :family_name, :given_name, :family_name_kana, :given_name_kana,
      :birthday, :gender
    )
  end

  def home_address_params
    @params.required(:home_address).except(:phones).permit(
      :postal_code, :prefecture, :city, :address1, :address2,
    )
  end

  def work_address_params
    @params.required(:work_address).except(:phones).permit(
    :company_name, :division_name,  :postal_code, :prefecture, :city, :address1, :address2,
    )
  end

  def phone_params(record_name)
    @params.required(record_name).slice(:phones).permit(phones: [ :number, :primary])
  end

end