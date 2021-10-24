FactoryBot.define do
  factory :customer do
    sequence(:email) { |n| "customer#{n}@example.com" }
    family_name { "山田" }
    given_name { "太郎" }
    family_name_kana { "ヤマダ" }
    given_name_kana { "タロウ" }
    password { "password" }
    birthday { Date.new(1970, 1 , 1) }
    gender { "male" }
    association :home_address, strategy: :build
    association :work_address, strategy: :build
  end
end