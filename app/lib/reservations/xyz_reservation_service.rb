# frozen_string_literal: true

module Reservations
  # Xyz would be replaced with the actual name of the data source
  # eg AirBnb etc
  class XyzReservationService < ReservationService
    def required_keys
      %w[
        reservation_code
        start_date
        end_date
        guest.email
      ]
    end

    def reservation_transform
      {
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
      }
    end

    def guest_transform
      {
        'guest.email' => 'email',
        'guest.first_name' => 'first_name',
        'guest.last_name' => 'last_name'
      }
    end

    def source_code
      'xyz'
    end
  end
end
