# frozen_string_literal: true

module Reservations
  # Xyz would be replaced with the actual name of the data source eg AirBnb etc
  class ReservationService
    def required_keys
      raise 'Implement me in your derived class'
    end

    def reservation_transform
      raise 'Implement me in your derived class'
    end

    def guest_transform
      raise 'Implement me in your derived class'
    end

    # A string code that will identify the source of the reservation
    def source_code
      raise 'Implement me in your derived class'
    end

    # Returns true if the service can process the payload
    # payload can be Parameters or Hash
    def accepts?(payload)
      HashUtils.keys?(payload, required_keys)
    end

    # payload is a hash
    def build_or_update(payload)
      reservation_params = HashUtils.transform_hash(payload, reservation_transform)
      reservation = Reservation.find_or_initialize_by(code: reservation_params['code'])
      guest = build_or_update_guest(payload)
      reservation.update(
        reservation_params.merge('guest' => guest, 'source' => source_code)
      )
      # TODO: phone numbers
      reservation
    end

    private

    def build_or_update_guest(payload)
      guest_params = HashUtils.transform_hash(payload, guest_transform)
      guest = Guest.find_or_initialize_by(email: guest_params['email'])
      guest.update(guest_params)
      guest
    end
  end
end
