require 'rails_helper'

RSpec.describe Administrator, type: :model do
  describe "#password" do
    it "文字列を与えると、hashed_passwordが60文字の文字列になる" do
      admin = Administrator.new
      admin.password = "password"
      expect(admin.hashed_password).to be_kind_of(String)
      expect(admin.hashed_password.size).to eq(60)
    end

    it "nilを与えると、hashed_passwordはnilになる" do
      admin = Administrator.new
      admin.password = nil
      expect(admin.hashed_password).to eq nil
    end
  end
end
