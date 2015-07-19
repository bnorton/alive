FactoryGirl.define do
  factory :user do
    sequence(:email) {|i| "john+#{i}@factories.example.com" }
    sequence(:password) {|i| "my-password-#{i}" }
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

  factory :hook do
    association(:test)
    url "https://www.example.com/test"
    name "A Hook Name"
  end

end
