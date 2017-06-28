class DeviceTypesController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user

  def new
    @device_type  = DeviceType.new
  end

  def create
    @device_type = DeviceType.new(device_type_params)
    if @device_type.save
      flash[:success] = 'Device type created successfully.'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def show
    @device_type = DeviceType.find(params[:id])
  end

  def edit
    @device_type = DeviceType.find(params[:id])
    @device_brands = DeviceBrand.all
    @device_types  = DeviceType.all
  end

  def update
    @device_type = DeviceType.find(params[:id])
    if @device_type.update_attributes(device_type_params)
      flash[:success] = "Device type updated"
      redirect_to @device_type
    else
      render 'edit'
    end
  end

  def destroy
    device_type = DeviceType.find(params[:id])
    device_type.destroy
    flash[:success] = "Device type #{device_type.name} deleted"
    redirect_to root_url
  end

  # Private methods
  private

    # Strong parameters for security
    def device_type_params
      params.require(:device_type).permit(:name)
    end
end
