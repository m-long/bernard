class KeysController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user

  def new
    @key  = Key.new
  end

  def create
    @key = Key.new(key_params)
    if @key.save
      flash[:success] = 'Key created successfully.'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def show
    @key = Key.find(params[:id])
  end

  def edit
    @key = Key.find(params[:id])
  end

  def update
    @key = Key.find(params[:id])
    if @key.update_attributes(key_params)
      flash[:success] = "Key updated"
      redirect_to remote_key_path(@key)
    else
      render 'edit'
    end
  end

  def destroy
    key = Key.find(params[:id])
    key.destroy
    flash[:success] = "Key #{key.name} deleted"
    redirect_to root_url
  end

  # Private methods
  private

    # Strong parameters for security
    def key_params
      params.require(:key).permit(:name, :value, :remote_ids => [])
    end
end
