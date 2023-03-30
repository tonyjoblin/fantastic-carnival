# frozen_string_literal: true

class ReservationsController < ApplicationController
  wrap_parameters false
  before_action :set_reservation, only: %i[show]

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
  # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
  def create
    service = Reservations::ServiceMatcher.service_for_payload(reservation_params.to_hash)
    if service.nil?
      Rails.logger.error "Unknown reservation format #{reservation_params.inspect}"
      render json: { errors: 'Reservation dose not match known format' }, status: :unprocessable_entity
      return
    end

    @reservation = service.build_or_update(reservation_params.to_hash)

    if @reservation.valid?
      render json: @reservation.to_json(include: { guest: { include: { phones: { only: [:number] } } } }),
             status: :created, location: @reservation
    else
      log_reservation_invalid(@reservation, service.class)
      render json: @reservation.errors, status: :unprocessable_entity
    end

  rescue StandardError => error
    Rails.logger.error("#{error}, reservation parameters: #{reservation_params.to_hash}")
    render json: "Failed to create the reservation #{error}", status: :unprocessable_entity
  end
  # rubocop:enable Metrics/MethodLength,Metrics/AbcSize

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

  def log_reservation_invalid(reservation, service_class)
    Rails.logger.error(
      "Reservation processed with #{service_class} is invalid. " \
      "Reservation: #{reservation_params.to_hash}. Errors: #{reservation.errors}"
    )
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_reservation
    @reservation = Reservation.where("id = ? OR code = ?", params[:id], params[:id]).first!
  end

  def reservation_params
    params.permit!
  end
end
