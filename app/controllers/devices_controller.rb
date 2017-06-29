class DevicesController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user, only: :destroy

  def new
    @device        = Device.new
    @device_models = DeviceModel.all
    @locations     = current_user.locations
  end

  def create
    @device = Device.new(device_params)
    if @device.save
      flash[:success] = 'Device created successfully.'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def show
    @device = Device.find(params[:id])
  end

  def edit
    @device        = Device.find(params[:id])
    @device_models = DeviceModel.all
    @locations     = current_user.locations
  end

  def update
    @device = Device.find(params[:id])
    if @device.update_attributes(device_params)
      flash[:success] = "Device updated"
      redirect_to user_location_device_path(@device)
    else
      render 'edit'
    end
  end

  def destroy
    device = Device.find(params[:id])
    device.destroy
    flash[:success] = "Device #{device.name} deleted"
    redirect_to root_url
  end

  # Private methods
  private

    # Strong parameters for security
    def device_params
      params.require(:device).permit(:name, :location_id,
                                     :device_model_id)
    end
end
