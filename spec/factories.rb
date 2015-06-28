FactoryGirl.define do
  factory :user do
    sequence(:email) {|i| "john+#{i}@factories.example.com" }
  end

end
