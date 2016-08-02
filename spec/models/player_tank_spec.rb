require 'rails_helper'

describe PlayerTank do
  it {is_expected.to be_a(Mongoid::Document)}
  it {is_expected.to be_a(Mongoid::Attributes::Dynamic)}
  it { is_expected.to be_embedded_in(:player) }
  it { is_expected.to belong_to(:tank) }
  it { is_expected.to have_field(:fetched_at).of_type(DateTime) } 
end
