FactoryGirl.define do

  factory :player_tank do
    initialize_with { new(attributes) }
    association :player
  end

end
