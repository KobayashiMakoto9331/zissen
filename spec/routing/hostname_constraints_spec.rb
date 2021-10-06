require "rails_helper"

describe "ルーティング" do
  it "職員トップページ" do
    config = Rails.application.config.baukis2
    url = "http://#{config[:staff][:host]}/#{config[:staff][:path]}"
    expect(get: url).to route_to(
      host: "#{config[:staff][:host]}",
      controller: "staff/top",
      action: "index"
    )
  end

  it "管理者ログインフォーム" do
    config = Rails.application.config.baukis2
    url = "http://#{config[:admin][:host]}/#{config[:admin][:path]}/login"
    expect(get: url).to route_to(
      host: "#{config[:admin][:host]}",
      controller: "admin/sessions",
      action: "new"
    )
  end

  it "顧客トップページ" do
    config = Rails.application.config.baukis2
    url = "http://#{config[:customer][:host]}/#{config[:customer][:path]}"
    expect(get: url).to route_to(
      host: "#{config[:customer][:host]}",
      controller: "customer/top",
      action: "index"
    )
  end

  it "ホスト名が対象外ならroutableではない" do
    expect(get: "http://foo.example.com").not_to be_routable
  end

  it "存在しないパスならroutableではない" do
    config = Rails.application.config.baukis2
    expect(get: "http://#{config[:staff][:host]}/#{config[:staff][:path]}/XYZ").not_to be_routable
  end
end