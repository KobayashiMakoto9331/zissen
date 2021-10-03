require "rails_helper"

describe Admin::Authenticator do
  describe "#authenticate"do
    it "正しいパスワードならtrueを返す" do
      a = build(:administrator)
      expect(Admin::Authenticator.new(a).authenticate("password")).to be_truthy
    end

    it "誤ったパスワードならfalseを返す" do
      a = build(:administrator)
      expect(Admin::Authenticator.new(a).authenticate("xy")).to be_falsey
    end

    it "パスワード未設定ならfalseを返す" do
      a = build(:administrator, password: nil)
      expect(Admin::Authenticator.new(a).authenticate("password")).to be_falsey
    end

    it "停止フラグが立っていてもtrueを返す" do
      a = build(:administrator, suspended: true)
      expect(Admin::Authenticator.new(a).authenticate("password")).to be_truthy
    end
  end
end