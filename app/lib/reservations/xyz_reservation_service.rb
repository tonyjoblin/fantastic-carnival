# frozen_string_literal: true

module Reservations
  # Xyz would be replaced with the actual name of the data source
  # eg AirBnb etc
  class XyzReservationService
    REQUIRED_KEYS = %w[
      reservation_code
      start_date
      end_date
      guest.email
    ].freeze

    RESERVATION_TRANSFORM = {
      'reservation_code' => 'code',
      'start_date' => 'start_date',
      'end_date' => 'end_date',
      'nights' => 'nights',
      'guests' => 'guests',
      'adults' => 'adults',
      'children' => 'children',
      'infants' => 'infants',
      'status' => 'status',
      'currency' => 'currency',
      'security_price' => 'security_deposit',
      'payout_price' => 'payout_amount',
      'total_price' => 'total_paid'
    }.freeze

    GUEST_TRANSFORM = {
      'guest.email' => 'email',
      'guest.first_name' => 'first_name',
      'guest.last_name' => 'last_name',
      'guest.phone' => 'phones'
    }.freeze

    SERVICE_CODE = 'xyz'

    def initialize
      @service_instance = Reservations::ReservationService.new(
        REQUIRED_KEYS, RESERVATION_TRANSFORM, GUEST_TRANSFORM, SERVICE_CODE
      )
    end

    delegate :accepts?, :build_or_update, to: :@service_instance
  end
end
