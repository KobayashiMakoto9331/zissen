require "rails_helper"

describe "次回から自動でログインする" do
  let(:customer) { create(:customer) }
  
  it "チェックボックスをOFFにした時" do
    post customer_session_url,
      params: {
        customer_login_form: {
          email: customer.email,
          password: "password",
          remember_me: "0"
        }
      }
    expect(session).to have_key(:customer_id)
    expect(response.cookies).not_to have_key("customer_id")
  end

  it "チェックボックスをONにした時" do
    post customer_session_url,
      params: {
        customer_login_form: {
          email: customer.email,
          password: "password",
          remember_me: "1"
        }
      }
    expect(session).not_to have_key(:customer_id)
    expect(response.cookies["customer_id"]).to match(/[0-9a-f]{40}\z/)

    cookies = response.request.env["action_dispatch.cookies"].instance_variable_get(:@set_cookies)
    expect(cookies["customer_id"][:expires]).to be > 19.years.from_now
  end
end