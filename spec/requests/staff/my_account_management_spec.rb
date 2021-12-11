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

  describe "情報表示" do
    let(:staff_member) { create(:staff_member) }

    it "成功" do
      get staff_account_url
      expect(response.status).to eq(200)
    end

    it "停止フラグがセットされたら強制的にログアウト" do
      staff_member.update_column(:suspended, true)
      get staff_account_url
      expect(response).to redirect_to staff_root_path
    end

    it "セッションタイムアウト" do
      travel_to Staff::Base::TIMEOUT.from_now.advance(seconds: 1)
      get staff_account_url
      expect(response).to redirect_to staff_login_path
    end
  end

  describe "更新" do
    let(:params_hash) { attributes_for(:staff_member) }
    let(:staff_member) { create(:staff_member) }
    
    it "email属性を変更する" do
      params_hash.merge!(email: "test@example.com")
      patch staff_account_url,
        params: { id: staff_member.id, staff_member: params_hash, commit: "更新" }
      staff_member.reload
      expect(staff_member.email).to eq("test@example.com")
    end

    it "例外 ActionController::PamameterMissing が発生" do
      expect { patch staff_account_url(id: staff_member.id, commit: "更新") }.
        to raise_error(ActionController::ParameterMissing)
    end

    it "end_date の値の置き換えは不可能" do
      params_hash.merge!(end_date: Date.tomorrow)
      expect {
        patch staff_account_url,
          params: { id: staff_member.id, staff_member: params_hash, commit: "更新"}
      }.not_to change { staff_member.end_date }
    end
  end
end