# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :note do
    text "MyText"
    user nil
    pointer nil
  end
end
