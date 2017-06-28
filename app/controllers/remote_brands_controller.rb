class RemoteBrandsController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user

  def new
    @remote_brand = RemoteBrand.new
  end

  def create
    @remote_brand = RemoteBrand.new(remote_brand_params)
    if @remote_brand.save
      flash[:success] = 'Remote brand created successfully.'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def show
    @remote_brand = RemoteBrand.find(params[:id])
  end

  def edit
    @remote_brand = RemoteBrand.find(params[:id])
  end

  def update
    @remote_brand = RemoteBrand.find(params[:id])
    if @remote_brand.update_attributes(remote_brand_params)
      flash[:success] = "Remote brand updated"
      redirect_to @remote_brand
    else
      render 'edit'
    end
  end

  def destroy
    remote_brand = RemoteBrand.find(params[:id])
    remote_brand.destroy
    flash[:success] = "Remote brand #{remote_brand.name} deleted"
    redirect_to root_url
  end

  # Private methods
  private

    # Strong remote brand parameters for security
    def remote_brand_params
      params.require(:remote_brand).permit(:name)
    end
end
