# frozen_string_literal: true

module Reservations
  # Xyz would be replaced with the actual name of the data source eg AirBnb etc
  class AbcReservationService < ReservationService
    def required_keys
      # TODO: for a create we need guest first and last names, but
      # for updates we don't really need any of these
      %w[
        reservation.code
        reservation.start_date
        reservation.end_date
        reservation.guest_email
      ]
    end

    def source_code
      'abc'
    end

    def reservation_transform
      {
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
      }
    end

    def guest_transform
      {
        'reservation.guest_email' => 'email',
        'reservation.guest_first_name' => 'first_name',
        'reservation.guest_last_name' => 'last_name'
      }
    end
  end
end
