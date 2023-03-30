# frozen_string_literal: true

require 'test_helper'

class ServiceMatcherTest < ActiveSupport::TestCase
  test 'service_for_payload returns the correct service instance' do
    [
      ['reservations/xyz_reservation_payload.json', Reservations::XyzReservationService],
      ['reservations/abc_reservation_payload.json', Reservations::AbcReservationService]
    ].each do |test_file, klass|
      payload_json = file_fixture(test_file).read
      payload_hash = JSON.parse(payload_json)

      service = Reservations::ServiceMatcher.service_for_payload(payload_hash)

      assert_instance_of klass, service
    end
  end

  test 'service_for_payload returns nil if the payload format is unknown' do
    assert_nil Reservations::ServiceMatcher.service_for_payload('format' => 'bad')
  end
end
