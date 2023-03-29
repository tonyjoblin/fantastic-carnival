# frozen_string_literal: true

require 'test_helper'

class XyzReservationServiceTest < ActiveSupport::TestCase
  fixtures :reservations

  test '#accepts? returns true if it can parse the payload' do
    [
      ['reservations/xyz_reservation_payload.json', true],
      ['reservations/abc_reservation_payload.json', false]
    ].each do |payload_file, should_accept|
      payload_json = file_fixture(payload_file).read
      payload_hash = JSON.parse(payload_json)

      assert_equal should_accept, Reservations::XyzReservationService.new.accepts?(payload_hash)
    end
  end

  test '#build_or_update returns a Reservation' do
    result = Reservations::XyzReservationService.new.build_or_update({ 'guest' => {} })
    assert_instance_of Reservation, result
  end

  test '#build_or_update_or_update can create a new reservation for an existing guest' do
    payload_json = file_fixture('reservations/xyz_new_reservation_for_steve.json').read
    payload_hash = JSON.parse(payload_json)

    assert_difference 'Reservation.count' => 1, 'Guest.count' => 0 do
      reservation = Reservations::XyzReservationService.new.build_or_update(payload_hash)

      assert reservation.id.present?, 'Saved in db'
      assert_equal 'XYZ12345678', reservation.code, 'Sets the code'
      assert_equal Date.parse('2021-04-14'), reservation.start_date, 'Sets the start_date'
      assert_equal Date.parse('2021-04-18'), reservation.end_date, 'Sets the end_date'
      assert_equal guests(:steve).id, reservation.guest.id, 'Has the correct guest'
    end
  end

  test '#build_or_update can create a new reservation for a new guest' do
    payload_json = file_fixture('reservations/xyz_new_reservation_for_mary.json').read
    payload_hash = JSON.parse(payload_json)

    assert_difference ['Reservation.count', 'Guest.count'] do
      reservation = Reservations::XyzReservationService.new.build_or_update(payload_hash)

      assert reservation.id.present?, 'Saved in db'
      assert_equal 'XYZ222333', reservation.code, 'Sets the code'
      assert_equal Date.parse('2021-04-14'), reservation.start_date, 'Sets the start_date'
      assert_equal Date.parse('2021-04-18'), reservation.end_date, 'Sets the end_date'
      assert_equal 'mary@gmail.com', reservation.guest.email, 'Creates a new guest'
      assert reservation.valid?, 'Is valid'
    end
  end

  test '#build_or_update can update an existing reservation' do
    payload_json = file_fixture('reservations/xyz_new_reservation_for_steve.json').read
    payload_hash = JSON.parse(payload_json)
    original_reservation = Reservations::XyzReservationService.new.build_or_update(payload_hash)
    assert original_reservation.save
    original_reservation.reload

    payload_json = file_fixture('reservations/xyz_updated_reservation_for_steve.json').read
    payload_hash = JSON.parse(payload_json)

    assert_no_difference ['Reservation.count', 'Guest.count'] do
      reservation = Reservations::XyzReservationService.new.build_or_update(payload_hash)

      assert_equal original_reservation.id, reservation.id, 'Updates existing reservation'
      assert_equal original_reservation.code, reservation.code, 'Does not change the code'
      assert_equal Date.parse('2021-04-13'), reservation.start_date, 'Updates the start_date'
      assert_equal Date.parse('2021-04-19'), reservation.end_date, 'Updates the end_date'
      assert_equal guests(:steve).id, reservation.guest.id, 'Has the correct guest'
      assert reservation.valid?, 'Is valid'
    end
  end

  # TODO: if field is not present an existing value should not be erased
  # TODO: test nights, guests etc, prices etc
end
