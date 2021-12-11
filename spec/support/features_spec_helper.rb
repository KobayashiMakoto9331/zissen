module FeaturesSpecHelper
  def switch_namespace(namespace)
    config = Rails.application.config.baukis2
    Capybara.app_host = "http://" + config[namespace][:host]
  end

  def login_as_staff_member(staff_member, password="password")
    visit staff_login_path
    within("#login-form") do
      fill_in "Email", with: staff_member.email
      fill_in "Password", with: "password"
      click_on "ログイン"
    end
  end

  def login_as_customer(customer, password="password")
    visit customer_login_path
    within("#login-form") do
      fill_in "Email", with: customer.email
      fill_in "Password", with: password
      click_on "ログイン"
    end
  end
end