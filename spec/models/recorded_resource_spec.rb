require 'rails_helper'

describe RecordedResource do
  it {is_expected.to be_a(Mongoid::Document)}
  it { is_expected.to be_timestamped_document.with(:created) }
  it { is_expected.to have_field(:count).of_type(Integer) }
  it { is_expected.to be_embedded_in(:player) }
end
