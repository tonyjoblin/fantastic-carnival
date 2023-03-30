# frozen_string_literal: true

module Reservations
  class ReservationService
    def initialize(required_keys, reservation_transform, guest_transform, service_code)
      @required_keys = required_keys
      @reservation_transform = reservation_transform
      @guest_transform = guest_transform
      @service_code = service_code
    end

    # Returns true if the service can process the payload
    # payload can be Parameters or Hash
    def accepts?(payload)
      HashUtils.keys?(payload, @required_keys)
    end

    # payload is a hash
    def build_or_update(payload)
      reservation_params = HashUtils.transform_hash(payload, @reservation_transform)
      reservation = Reservation.find_or_initialize_by(code: reservation_params['code'])
      guest = build_or_update_guest(payload)
      guest = reservation.guest if guest.nil? # payload didn't specify guest, could be an update
      reservation.update(
        reservation_params.merge('guest' => guest, 'source' => @service_code)
      )
      reservation
    end

    private

    def build_or_update_guest(payload)
      guest_params = HashUtils.transform_hash(payload, @guest_transform)
      return nil unless guest_params.key? 'email'
      transform_guest_phone_numbers(guest_params)
      guest = Guest.find_or_initialize_by(email: guest_params['email'])
      guest.update(guest_params)
      guest
    end

    def transform_guest_phone_numbers(guest_params)
      return unless guest_params.key?('phones')

      if guest_params['phones'].is_a? Array
        guest_params['phones'] = guest_params['phones'].map { |number| Phone.new(number:) }
      elsif guest_params['phones'].is_a? String
        guest_params['phones'] = [Phone.new(number: guest_params['phones'])]
      end
    end
  end
end
