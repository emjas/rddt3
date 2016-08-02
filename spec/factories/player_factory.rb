FactoryGirl.define do

  factory :player do
    initialize_with { new(attributes) }
    nickname "TankerJoe"
    sequence :account_id do |aid|
      aid
    end
    factory :player_with_clan do
      association :clan
    end
    last_battle_time Time.now.to_i
  end

end
