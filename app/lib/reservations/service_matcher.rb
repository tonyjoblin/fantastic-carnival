# frozen_string_literal: true

module Reservations
  class ServiceMatcher
    RESERVATION_SERVICES = [
      Reservations::XyzReservationService,
      Reservations::AbcReservationService
    ].freeze
    def self.service_for_payload(payload)
      RESERVATION_SERVICES.each do |service_klass|
        service = service_klass.new
        return service if service.accepts?(payload)
      end
      nil
    end
  end
end
