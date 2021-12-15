class Customer < ApplicationRecord
  include PersonalNameHolder
  include EmailHolder
  include PasswordHolder

  has_many :addresses, dependent: :destroy
  has_one :home_address, autosave: true
  has_one :work_address, autosave: true
  has_many :phones, dependent: :destroy
  has_many :personal_phones, ->{ where(address_id: nil).order(:id)},
    class_name: "Phone", autosave: true
  has_many :entries, dependent: :destroy
  has_many :programs, through: :entries
  has_many :messages
  has_many :outbound_messages, class_name: "CustomerMessages", foreign_key: "customer_id"
  has_many :inbound_messages, class_name: "StaffMessage", foreign_key: "customer_id"

  validates :gender, inclusion: { in: %w(male female), allow_blank: true }
  validates :birthday, date: {
    after: Date.new(1900, 1, 1),
    before: -> (obj) { Date.today },
    allow_blank: true
  }

end
