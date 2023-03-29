class ReservationsController < ApplicationController
  wrap_parameters false
  before_action :set_reservation, only: %i[ show ]

  # GET /reservations
  # def index
  #   @reservations = Reservation.all
  #   render json: @reservations
  # end

  # GET /reservations/1
  def show
    render json: @reservation
  end

  # POST /reservations
  def create
    if Reservations::XyzReservationService.new.accepts?(reservation_params.to_hash)
      @reservation = Reservations::XyzReservationService.new.build_or_update(reservation_params.to_hash)
      render json: @reservation, status: :created, location: @reservation
    else
      render json: { errors: "TODO" }, status: :unprocessable_entity
    end

    # @reservation = Reservation.new(reservation_params)

    # if @reservation.save
    #   render json: @reservation, status: :created, location: @reservation
    # else
    #   render json: @reservation.errors, status: :unprocessable_entity
    # end
  end

  # PATCH/PUT /reservations/1
  # def update
  #   if @reservation.update(reservation_params)
  #     render json: @reservation
  #   else
  #     render json: @reservation.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /reservations/1
  # Not going to implement, probably not appropriate
  # should rather update a reservation and set status to cancelled?

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def reservation_params
      params.permit!
    end
end
