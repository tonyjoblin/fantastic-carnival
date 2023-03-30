# frozen_string_literal: true

require 'test_helper'

class AbcReservationServiceTest < ActiveSupport::TestCase
  fixtures :reservations

  def setup
    @service = Reservations::AbcReservationService.new
  end

  test '#accepts? returns true if it can parse the payload' do
    [
      ['reservations/xyz_reservation_payload.json', false],
      ['reservations/abc_reservation_payload.json', true]
    ].each do |payload_file, should_accept|
      payload_json = file_fixture(payload_file).read
      payload_hash = JSON.parse(payload_json)

      assert_equal should_accept, @service.accepts?(payload_hash)
    end
  end

  test '#build_or_update returns a Reservation' do
    result = @service.build_or_update({ 'guest' => {} })
    assert_instance_of Reservation, result
  end

  test '#build_or_update_or_update can create a new reservation for an existing guest' do
    payload_json = file_fixture('reservations/abc_new_reservation_for_steve.json').read
    payload_hash = JSON.parse(payload_json)

    assert_difference 'Reservation.count' => 1, 'Guest.count' => 0 do
      reservation = @service.build_or_update(payload_hash)

      assert reservation.valid?, 'Reservation is valid'
      assert reservation.id.present?, 'Saved in db'
      assert_equal 'XXXforsteve', reservation.code, 'Sets the code'
      assert_equal Date.parse('2021-03-12'), reservation.start_date, 'Sets the start_date'
      assert_equal Date.parse('2021-03-16'), reservation.end_date, 'Sets the end_date'
      # TODO
      # assert_equal 4, reservation.guests, 'Sets the number of guests'
      assert_equal 2, reservation.adults, 'Sets adults count'
      assert_equal 2, reservation.children, 'Sets children count'
      assert_equal 0, reservation.infants, 'Sets infants count'
      assert_equal 500, reservation.security_deposit, 'Sets security deposit'
      assert_equal 3800, reservation.payout_amount, 'Sets payout amount'
      assert_equal 4300, reservation.total_paid, 'Sets total paid'

      assert_equal guests(:steve).id, reservation.guest.id, 'Has the correct guest'
    end
  end

  test '#build_or_update can create a new reservation for a new guest' do
    payload_json = file_fixture('reservations/abc_new_reservation_for_karen.json').read
    payload_hash = JSON.parse(payload_json)

    assert_difference ['Reservation.count', 'Guest.count'] do
      reservation = @service.build_or_update(payload_hash)

      assert reservation.valid?, 'Reservation is valid'
      assert reservation.id.present?, 'Saved in db'
      assert_equal 'XXXforkaren', reservation.code, 'Sets the code'
      assert_equal Date.parse('2021-03-12'), reservation.start_date, 'Sets the start_date'
      assert_equal Date.parse('2021-03-16'), reservation.end_date, 'Sets the end_date'
      # TODO
      # assert_equal 4, reservation.guests, 'Sets the number of guests'
      assert_equal 2, reservation.adults, 'Sets adults count'
      assert_equal 2, reservation.children, 'Sets children count'
      assert_equal 0, reservation.infants, 'Sets infants count'
      assert_equal 500, reservation.security_deposit, 'Sets security deposit'
      assert_equal 3800, reservation.payout_amount, 'Sets payout amount'
      assert_equal 4300, reservation.total_paid, 'Sets total paid'

      # creates guest
      assert_equal 'karen@gmail.com', reservation.guest.email, 'Creates a new guest'
      assert_equal 'Karen', reservation.guest.first_name, 'Sets first name'
      assert_equal 'Kole', reservation.guest.last_name, 'Sets last name'
    end
  end

  test '#build_or_update can update an existing reservation' do
    payload_json = file_fixture('reservations/abc_new_reservation_for_steve.json').read
    payload_hash = JSON.parse(payload_json)
    original_reservation = @service.build_or_update(payload_hash)
    assert original_reservation.valid?
    assert original_reservation.id.present?

    payload_json = file_fixture('reservations/abc_updated_reservation_for_steve.json').read
    payload_hash = JSON.parse(payload_json)

    assert_no_difference ['Reservation.count', 'Guest.count'] do
      reservation = @service.build_or_update(payload_hash)

      assert reservation.valid?, 'Is valid'
      assert_equal original_reservation.id, reservation.id, 'Updates existing reservation'
      assert_equal original_reservation.code, reservation.code, 'Does not change the code'
      assert_equal guests(:steve).id, reservation.guest.id, 'Has the correct guest'

      # updated attributes
      assert_equal Date.parse('2021-03-18'), reservation.end_date, 'Updates the end_date'
      assert_equal 1, reservation.children, 'Updates the children count'
      assert_equal 1, reservation.infants, 'Updates the infants count'
      assert_equal 6, reservation.nights, 'Updates the number of nights'
      assert_equal 4600, reservation.payout_amount, 'Updates the number of nights'
      assert_equal 5140, reservation.total_paid, 'Updates the number of nights'
    end
  end
end
