# frozen_string_literal: true

module Reservations
  class XyzGuestService
    # payload is a hash
    def build_or_update(payload)
      guest = Guest.find_or_initialize_by(email: payload['email'])
      guest.update(payload.slice('first_name', 'last_name'))
      # TODO: handle phone numbers
      guest
    end
  end
end
