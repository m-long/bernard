class DeviceBrandsController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user

  def new
    @device_brand = DeviceBrand.new
  end

  def create
    @device_brand = DeviceBrand.new(device_brand_params)
    if @device_brand.save
      flash[:success] = 'DeviceBrand created successfully.'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def show
    @device_brand = DeviceBrand.find(params[:id])
  end

  def edit
    @device_brand = DeviceBrand.find(params[:id])
  end

  def update
    @device_brand = DeviceBrand.find(params[:id])
    if @device_brand.update_attributes(device_brand_params)
      flash[:success] = "Device brand updated"
      redirect_to @device_brand
    else
      render 'edit'
    end
  end

  def destroy
    device_brand = DeviceBrand.find(params[:id])
    device_brand.destroy
    flash[:success] = "Device brand #{device_brand.name} deleted"
    redirect_to root_url
  end

  # Private methods
  private

    # Strong remote parameters for security
    def device_brand_params
      params.require(:device_brand).permit(:name)
    end
end
