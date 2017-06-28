class DeviceModelsController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user

  def new
    @device_model  = DeviceModel.new
    @device_brands = DeviceBrand.all
    @device_types  = DeviceType.all
  end

  def create
    @device_model = DeviceModel.new(device_model_params)
    if @device_model.save
      flash[:success] = 'Device model created successfully.'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def show
    @device_model = DeviceModel.find(params[:id])
  end

  def edit
    @device_model = DeviceModel.find(params[:id])
  end

  def update
    @device_model = DeviceModel.find(params[:id])
    if @device_model.update_attributes(device_model_params)
      flash[:success] = "Device model updated"
      redirect_to @device_model
    else
      render 'edit'
    end
  end

  def destroy
    device_model = DeviceModel.find(params[:id])
    device_model.destroy
    flash[:success] = "Device model #{device_model.name} deleted"
    redirect_to root_url
  end

  # Private methods
  private

    # Strong parameters for security
    def device_model_params
      params.require(:device_model).permit(:model, :device_type_id, :device_brand_id)
    end
end
