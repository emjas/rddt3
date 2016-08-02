require 'rails_helper'

feature "Listing users" do

  before(:example) do
    @clan = create(:clan_with_players, players_count: 5, abbreviation: 'RDDT3')
  end

  scenario "viewing index page" do
    visit '/'
    expect(page).to have_content 'Roster'
  end

end
