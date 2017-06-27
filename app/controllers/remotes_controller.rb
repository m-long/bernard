class RemotesController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :admin_user,     only: :destroy

  def new
    @remote = Remote.new
  end

  def create
    @remote = Remote.new(remote_params)
    if @remote.save
      flash[:success] = 'Remote created successfully.'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def show
    @remote = Remote.find(params[:id])
  end

  def edit
    @remote = Remote.find(params[:id])
  end

  def update
    @remote = Remote.find(params[:id])
    if @remote.update_attributes(remote_params)
      flash[:success] = "Remote updated"
      redirect_to @remote
    else
      render 'edit'
    end
  end

  def destroy
    remote = Remote.find(params[:id])
    remote.destroy
    flash[:success] = "Remote #{remote.name} deleted"
    redirect_to root_url
  end

  # Private methods
  private

    # Strong remote parameters for security
    def remote_params
      params.require(:remote).permit(:name, :brand, :model,
                                     :supported_devices, :bits, :flags,
                                     :include, :manual_sort,
                                     :suppress_repeat, :driver, :eps,
                                     :aeps, :header,
                                     :zero, :one, :two, :three,
                                     :ptrail, :plead, :foot, :repeat,
                                     :pre_data_bits, :pre_data,
                                     :post_data_bits, :post_data,
                                     :pre, :post, :gap, :repeat_gap,
                                     :min_repeat, :toggle_bit,
                                     :toggle_bit_mask, :repeat_mask,
                                     :frequency, :duty_cycle
                                    )
    end
end
