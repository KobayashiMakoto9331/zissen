require "rails_helper"

describe "職員による自分のアカウントの管理" do
  before do
    post staff_session_url,
      params: {
        staff_login_form: {
          email: staff_member.email,
          password: "password"
        }
      }
  end

  describe "更新" do
    let(:params_hash) { attributes_for(:staff_member) }
    let(:staff_member) { create(:staff_member) }
    
    it "email属性を変更する" do
      params_hash.merge!(email: "test@example.com")
      patch staff_account_url,
        params: { id: staff_member.id, staff_member: params_hash }
      staff_member.reload
      expect(staff_member.email).to eq("test@example.com")
    end

    it "例外 ActionController::PamameterMissing が発生" do
      expect { patch staff_account_url(staff_member) }.
        to raise_error(ActionController::ParameterMissing)
    end

    it "end_date の値の置き換えは不可能" do
      params_hash.merge!(end_date: Date.tomorrow)
      expect {
        patch staff_account_url,
          params: { id: staff_member.id, staff_member: params_hash}
      }.not_to change { staff_member.end_date }
    end
  end
end