# frozen_string_literal: true

module Reservations
  # Xyz would be replaced with the actual name of the data source
  # eg AirBnb etc
  class XyzReservationService
    # payload can be Parameters or Hash
    def accepts?(payload)
      required_keys = %w[
        reservation_code
        start_date
        end_date
        guest.email
      ]
      # TODO: for a create we need guest first and last names, but
      # for updates we don't really need any of these
      HashUtils.has_keys?(payload, required_keys)
    end

    # payload is a hash
    def build_or_update(payload)
      reservation = Reservation.find_or_initialize_by(code: payload['reservation_code'])
      guest = Reservations::XyzGuestService.new.build_or_update(payload['guest'])
      reservation_params = HashUtils.transform_hash(
        payload,
        {
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
      )
      reservation.update(
        reservation_params.merge('guest' => guest, 'source' => 'xyz')
      )
      # TODO: phone numbers
      reservation
    end
  end
end
