# frozen_string_literal: true

module Reservations
  # Xyz would be replaced with the actual name of the data source eg AirBnb etc
  class AbcReservationService
    REQUIRED_KEYS = %w[
      reservation.code
      reservation.start_date
      reservation.end_date
      reservation.guest_email
    ].freeze

    RESERVATION_TRANSFORM = {
      'reservation.code' => 'code',
      'reservation.start_date' => 'start_date',
      'reservation.end_date' => 'end_date',
      'reservation.nights' => 'nights',
      # 'guests' => 'guests', # TODO: this needs to be calculated?
      'reservation.guest_details.number_of_adults' => 'adults',
      'reservation.guest_details.number_of_children' => 'children',
      'reservation.guest_details.number_of_infants' => 'infants',
      'reservation.status_type' => 'status',
      'reservation.host_currency' => 'currency',
      'reservation.listing_security_price_accurate' => 'security_deposit',
      'reservation.expected_payout_amount' => 'payout_amount',
      'reservation.total_paid_amount_accurate' => 'total_paid'
    }.freeze

    GUEST_TRANSFORM = {
      'reservation.guest_email' => 'email',
      'reservation.guest_first_name' => 'first_name',
      'reservation.guest_last_name' => 'last_name',
      'reservation.guest_phone_numbers' => 'phones'
    }.freeze

    SERVICE_CODE = 'abc'

    def initialize
      @service_instance = Reservations::ReservationService.new(
        REQUIRED_KEYS, RESERVATION_TRANSFORM, GUEST_TRANSFORM, SERVICE_CODE
      )
    end

    delegate :accepts?, :build_or_update, to: :@service_instance
  end
end
