FactoryGirl.define do
  factory :user do
    sequence(:email) {|i| "john+#{i}@factories.example.com" }
  end

  factory :test do
    association(:user)
    sequence(:url) {|i| "https://#{i}.example.com/test" }
    breed 'get'
  end

  factory :test_run do
    association(:user)
    association(:test)
  end

  factory :check do
    association(:test)
  end
end
