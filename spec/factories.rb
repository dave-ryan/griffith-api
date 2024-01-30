FactoryBot.define do
  factory :user do
    name { FFaker::Name.first_name }
    family_id { 1 }
    santa_group { 1 }
    secret_santa_id { 2 }
    is_admin { false }
    password { "123" }
  end

  factory :user_without_secret_santa, :parent => :user do
    name { FFaker::Name.first_name }
    family_id { 1 }
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

  factory :gift do
    user_id { 1 }
    name { FFaker::Product.product }
  end

  factory :customgift do
    customgift_purchaser_id { 1 }
    user_id { 1 }
    note { FFaker::Product.product }
  end
end
