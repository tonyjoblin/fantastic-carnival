# frozen_string_literal: true

module Reservations
  # Xyz would be replaced with the actual name of the data source
  # eg AirBnb etc
  class XyzReservationService
    def accepts?(payload)
      # TODO: can we use dig here and also check guest.email?
      required_keys = %w[
        reservation_code
        start_date
        end_date
        guest
      ]
      required_keys.map { |key| payload.key?(key) }.all?
    end

    # payload is a hash
    def build_or_update(payload)
      reservation = Reservation.find_or_initialize_by(code: payload['reservation_code'])
      guest = Reservations::XyzGuestService.new.build_or_update(payload['guest'])
      reservation.update(
        payload.slice('start_date', 'end_date').merge('guest' => guest, 'source' => 'xyz')
      )
      # TODO: nights
      # TODO: guests
      # TODO: adults
      # TODO: children
      # TODO: infants
      # TODO: currency
      # TODO: prices
      reservation
    end
  end
end
