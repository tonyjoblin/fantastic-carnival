# frozen_string_literal: true

require 'test_helper'

class ReservationTest < ActiveSupport::TestCase
  test 'validates that required fields are present' do
    reservation = Reservation.new

    assert reservation.invalid?
    assert reservation.errors[:code].any?, 'A reservation must have a code'
    assert reservation.errors[:start_date].any?, 'Must have a start date'
    assert reservation.errors[:end_date].any?, 'Must have an end date'
    assert reservation.errors[:guest].any?, 'Must have a guest'
    assert reservation.errors[:source].any?, 'Must have a source'

    steve = guests(:steve)
    reservation.code = 'xyz123'
    reservation.start_date = '2023-03-29'
    reservation.end_date = '2023-04-29'
    reservation.guest = steve
    reservation.source = 'xyz'

    assert reservation.valid?, 'Must be valid'
  end
end
