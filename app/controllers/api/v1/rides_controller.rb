class Api::V1::RidesController < ApplicationController
  # include ApplicationHelper

  before_action :authorize_request

  # skip_before_action :verify_authenticity_token

  def index
    @rides = Ride.all
    render json: @rides
  end

  def new
    @ride = Ride.new
  end

  def create
    @ride = Ride.new(ride_params)
    if @ride.save
      render json: {success: true, ride: @ride}
    else
      render json: { success: false, error: @ride.errors.messages }
    end
  end

  def edit
    @ride = Ride.new(ride_params)
  end

  def update
    @ride = Ride.new(ride_params)
    if @ride.update(ride_params)
      render json: {success: true, ride: @ride}
    else
      render json: { success: false, error: @ride.errors.messages }
    end
  end

  def destroy
    @ride = Ride.find(params[:id])
    @ride.destroy
  end

  def ride_params
    params.require(:ride).permit(:name)
  end
end
