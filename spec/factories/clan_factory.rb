FactoryGirl.define do

  factory :clan do
    initialize_with { new(attributes) }
    sequence :clan_id do |cid|
      cid
    end
    factory :clan_with_players do
      transient do
        players_count 1
      end
      after(:build) do |clan, evaluator|
        clan['members'] = {}
        evaluator.players_count.times do
          player = build(:player)
          member = {"created_at"=>DateTime.now.to_i, "role"=>"recruit", "role_i18n"=>"Recruit", "account_id"=>player['account_id'].to_i, "account_name"=>"Tanker"}
          clan.players.push(player)
          clan['members'][member['account_id'].to_s] = member
        end
      end
      after(:create) do |clan, evaluator|
        clan.players.map(&:save) # FSR isn't saving children when parent is saved, weird interaction between mongoid and factorygirl possibly
      end
      factory :clan_with_commander_member do
        after(:build) do |clan, evaluator|
          clan['members'][clan.members.keys.first]['role_i18n'] = 'Commander'
          clan['members'][clan.members.keys.first]['role'] = 'commander'
        end
      end
    end
  end
end
