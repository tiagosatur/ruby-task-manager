FactoryBot.define do
  factory :task do
    title { "MyString" }
    description { "MyText" }
    status { "MyString" }
    due_date { "2025-06-09 00:09:45" }
  end
end
