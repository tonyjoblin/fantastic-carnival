# frozen_string_literal: true

require 'test_helper'

class ReservationServiceTest < ActiveSupport::TestCase
  fixtures :reservations

  test '#accepts? returns true if it can parse the payload' do
    required_keys = %w[a b.c]

    service = Reservations::ReservationService.new(required_keys, nil, nil, nil)

    assert service.accepts?('a' => 5, 'b' => { 'c' => 7 }, 'd' => 'cat'),
           'Accepted, all required attributes present'

           assert_equal false, service.accepts?('b' => { 'c' => 7 }, 'd' => 'cat'),
                 'Not accepted, attribute \'a\' is missing'
  end

  test "#build_or_update can create a new reservation" do
    payload = {
      'code' => 'code',
      'start_date' => '2023-03-20',
      'end_date' => '2023-03-25',
      'guest_email' => 'email@foo.bar',
      'guest_first_name' => 'first name',
      'guest_last_name' => 'last name'
    }

    reservation_transform = {
      'code' => 'code',
      'start_date' => 'start_date',
      'end_date' => 'end_date'
    }

    guest_transform = {
      'guest_email' => 'email',
      'guest_first_name' => 'first_name',
      'guest_last_name' => 'last_name'
    }

    service = Reservations::ReservationService.new(nil, reservation_transform, guest_transform, 'xyz')

    reservation = service.build_or_update(payload)

    assert reservation.valid?
  end
end
