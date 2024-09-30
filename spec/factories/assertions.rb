FactoryBot.define do
  factory :assertion do
    url { Faker::Internet.url }
    text { Faker::Lorem.word }
    status { ["pass", "fail"].sample }
    num_links { rand(1..100) }
    num_images { rand(1..50) }
    created_at { Time.now }
  end
end
