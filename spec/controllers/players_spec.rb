require "rails_helper"

describe PlayersController do
  describe "GET #index" do
    before(:example) do
      @clan = create(:clan_with_players, players_count: 5, abbreviation: 'RDDT3')
    end

    it "loads RDDT3 Player instances into @players as first object in array" do
      get :index, clan_id: 'RDDT3'
      expect(assigns(:players).map{|player, eligibility| player}).to match_array(@clan.players)
    end

    it "loads soldier eligibility instances into @players as second object in array" do
      get :index, clan_id: "RDDT3"
      expect(assigns(:players).map{|player, eligibility| eligibility}).to match_array(@clan.players.map{|p| SoldierEligible.new(@clan, p)})
    end

    it "responds successfully with an HTTP 200 status code" do
      get :index, clan_id: 'RDDT3'
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the index template" do
      get :index, clan_id: 'RDDT3'
      expect(response).to render_template("index")
    end

    it "loads the clan into @clan" do
      get :index, clan_id: 'RDDT3'
      expect(assigns(:clan)).to eq(@clan)
    end
  end
end
