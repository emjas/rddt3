FactoryGirl.define do
  factory :recorded_resource do
    created_at Time.now
    count 1
    association :player
  end

end
