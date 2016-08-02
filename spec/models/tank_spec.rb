require 'rails_helper'

describe Tank do
  it {is_expected.to be_a(Mongoid::Document)}
  it {is_expected.to be_a(Mongoid::Attributes::Dynamic)}
  it { is_expected.to have_field(:fetched_at).of_type(DateTime) }

  it "sets _id to tank_id" do
    tank = build(:tank)
    expect(tank._id).to eq(tank.tank_id)
  end

  it "updates _id if tank_id is also updated" do
    tank = build(:tank)
    tank.tank_id = 'hahaha'
    expect(tank._id).to eq(tank.tank_id)
  end
end

