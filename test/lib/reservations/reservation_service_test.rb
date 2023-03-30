# frozen_string_literal: true

require 'test_helper'

class ReservationServiceTest < ActiveSupport::TestCase
  fixtures :reservations

  RESERVATION_TRANSFORM = {
    'code' => 'code',
    'start_date' => 'start_date',
    'end_date' => 'end_date',
    'guests' => 'guests',
    'adults' => 'adults'
  }.freeze

  GUEST_TRANSFORM = {
    'guest_email' => 'email',
    'guest_first_name' => 'first_name',
    'guest_last_name' => 'last_name',
    'guest_phone_numbers' => 'phones'
  }.freeze

  test '#accepts? returns true if it can parse the payload' do
    required_keys = %w[a b.c]

    service = Reservations::ReservationService.new(required_keys, nil, nil, nil)

    assert service.accepts?('a' => 5, 'b' => { 'c' => 7 }, 'd' => 'cat'),
           'Accepted, all required attributes present'

    assert_equal false, service.accepts?('b' => { 'c' => 7 }, 'd' => 'cat'),
                 'Not accepted, attribute \'a\' is missing'
  end

  test '#build_or_update can create a new reservation' do
    payload = {
      'code' => 'code',
      'start_date' => '2023-03-20',
      'end_date' => '2023-03-25',
      'guest_email' => 'email@foo.bar',
      'guest_first_name' => 'first name',
      'guest_last_name' => 'last name'
    }

    service = Reservations::ReservationService.new(nil, RESERVATION_TRANSFORM, GUEST_TRANSFORM, 'xyz')

    reservation = service.build_or_update(payload)

    assert reservation.valid?
  end

  test '#build_or_update can handle guest with single phone number' do
    payload = {
      'code' => 'code',
      'start_date' => '2023-03-20',
      'end_date' => '2023-03-25',
      'guest_email' => 'email@foo.bar',
      'guest_first_name' => 'first name',
      'guest_last_name' => 'last name',
      'guest_phone_numbers' => '123456'
    }

    service = Reservations::ReservationService.new(nil, RESERVATION_TRANSFORM, GUEST_TRANSFORM, 'xyz')

    reservation = service.build_or_update(payload)

    assert reservation.valid?
    assert_equal ['123456'], reservation.guest.phones.map(&:number)
  end

  test '#build_or_update can handle guest with an array of phone numbers' do
    payload = {
      'code' => 'code',
      'start_date' => '2023-03-20',
      'end_date' => '2023-03-25',
      'guest_email' => 'email@foo.bar',
      'guest_first_name' => 'first name',
      'guest_last_name' => 'last name',
      'guest_phone_numbers' => ['123456', '345-678-234']
    }

    service = Reservations::ReservationService.new(nil, RESERVATION_TRANSFORM, GUEST_TRANSFORM, 'xyz')

    reservation = service.build_or_update(payload)

    assert reservation.valid?
    assert_equal ['123456', '345-678-234'], reservation.guest.phones.map(&:number)
  end

  test '#build_or_update can update a reservation' do
    payload = {
      'code' => 'XYZ123', # existing reservation
      'guests' => 5, # new guest count
      'adults' => 2, # new adult count,
      'guest_email' => 'steve@gmail.com'
    }

    service = Reservations::ReservationService.new(nil, RESERVATION_TRANSFORM, GUEST_TRANSFORM, 'xyz')

    reservation = service.build_or_update(payload)

    assert reservation.valid?

    # existing fields
    assert_equal Date.parse('2023-03-28'), reservation.start_date
    assert_equal Date.parse('2023-04-05'), reservation.end_date
    assert_equal 1, reservation.nights
    assert_equal 1, reservation.children
    assert_equal 1, reservation.infants
    assert_equal 'accepted', reservation.status
    assert_equal 'AUD', reservation.currency
    assert_equal 9.99, reservation.security_deposit
    assert_equal 9.99, reservation.payout_amount
    assert_equal 9.99, reservation.total_paid
    assert_equal 'xyz', reservation.source

    # updated field
    assert_equal 5, reservation.guests
    assert_equal 2, reservation.adults
  end

  test '#build_or_update should not need guest for update' do
    payload = {
      'code' => 'XYZ123', # existing reservation
      'guests' => 5, # new guest count
      'adults' => 2, # new adult count,
    }

    service = Reservations::ReservationService.new(nil, RESERVATION_TRANSFORM, GUEST_TRANSFORM, 'xyz')

    reservation = service.build_or_update(payload)

    assert reservation.valid?

    # updated field
    assert_equal 5, reservation.guests
    assert_equal 2, reservation.adults
  end
end
