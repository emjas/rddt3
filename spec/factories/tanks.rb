FactoryGirl.define do
  factory :tank do
    initialize_with { new(attributes) }
    level 1
    is_premium false
    sequence :tank_id do |tid|
      tid
    end
  end

end
