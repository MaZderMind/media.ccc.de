class Api::ConferencesController < InheritedResources::Base
  before_filter :authenticate_api_key!
  protect_from_forgery :except => :create
  respond_to :json

  def create
    @conference = Conference.new
    @conference.update_attributes(params[:conference].permit([:acronym, :schedule_url, :recordings_path, :images_path, :webgen_location, :aspect_ratio]))

    respond_to do |format|
      if not @conference.schedule_url.nil? and @conference.save
        @conference.url_changed
        format.json { render json: @conference, status: :created }
      else
        format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end


  private

  def permitted_params
    {:conference => params.require(:conference).permit(:acronym, :schedule_url, :recordings_path, :images_path, :webgen_location, :aspect_ratio)}
  end
end