class LocationsController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user

  def new
    @location  = Location.new
  end

  def create
    @location = current_user.locations.new(location_params)
    if @location.save
      flash[:success] = 'Location created successfully.'
      redirect_to user_location_path(@location)
    else
      render 'new'
    end
  end

  def show
    @location = Location.find(params[:id])
  end

  def edit
    @location = Location.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])
    if @location.update_attributes(location_params)
      flash[:success] = "Location updated"
      redirect_to user_location_path(@location)
    else
      render 'edit'
    end
  end

  def destroy
    location = Location.find(params[:id])
    location.destroy
    flash[:success] = "Location #{location.name} deleted"
    redirect_to root_url
  end

  # Private methods
  private

    # Strong parameters for security
    def location_params
      params.require(:location).permit(:name)
    end
end
