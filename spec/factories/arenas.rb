# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :arena do
    hero "MyString"
    complete false
    user nil
  end
end
