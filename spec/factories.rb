FactoryBot.define do
  factory :user do
    name { FFaker::Name.first_name }
    family_id { 1 }
    santa_group { 1 }
    secret_santa_id { 2 }
    is_admin { false }
    password { "123" }
  end

  factory :admin_user, :parent => :user do
    name { "admin" }
    is_admin { true }
    password { "123" }
  end

  factory :family do
    name { FFaker::Name.last_name }
  end
end
