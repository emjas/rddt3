class ResourcesController < ApplicationController
  http_basic_authenticate_with name: "some_username", password: "some_password"

  def index
    @resources = Player.all.map{|p| p.latest_recorded_resource}.compact
  end

  def create
    if RecordedResource.process_input(params[:resources_dump])
      flash.alert = nil
    else
      flash.alert = "Invalid copypaste data from WoT Strongholds page."
    end
    @resources = Player.all.map{|p| p.latest_recorded_resource}.compact
    render :index
  end

end
