# frozen_string_literal: true

require 'test_helper'

class ReservationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reservation = reservations(:one)
  end

  test 'should get index' do
    # not implemented
    assert_raises ActionController::RoutingError do
      get reservations_url, as: :json
    end
  end

  [
    ['reservations/xyz_new_reservation_for_mary.json', 'xyz'],
    ['reservations/abc_new_reservation_for_paul.json', 'abc']
  ].each do |test_file, source|
    test "should create reservation from #{source} source data" do
      payload_json = file_fixture(test_file).read
      payload_hash = JSON.parse(payload_json)

      assert_difference 'Reservation.count', 1, "failed to create reservation for #{test_file}" do
        post reservations_url, params: payload_hash, as: :json
      end

      assert_response :created
    end
  end

  test 'create should return the created reservation including the guest and phone numbers' do
    payload_json = file_fixture('reservations/xyz_new_reservation_for_mary.json').read
    payload_hash = JSON.parse(payload_json)

    assert_difference 'Reservation.count' do
      post reservations_url, params: payload_hash, as: :json
    end

    assert_response :created

    reservation = response.parsed_body

    assert reservation.key? 'id'
    assert_equal 'XYZ222333', reservation['code']
    assert_equal '2021-04-14', reservation['start_date']
    assert_equal '2021-04-18', reservation['end_date']
    assert_equal 4, reservation['nights']
    assert_equal 1, reservation['guests']
    assert_equal 1, reservation['adults']
    assert_equal 0, reservation['children']
    assert_equal 0, reservation['infants']
    assert_equal 'accepted', reservation['status']
    assert_equal 'AUD', reservation['currency']
    assert_equal '500.0', reservation['security_deposit']
    assert_equal '4200.0', reservation['payout_amount']
    assert_equal '4700.0', reservation['total_paid']
    assert_equal 'xyz', reservation['source']
    assert reservation.key? 'created_at'
    assert reservation.key? 'updated_at'
    assert reservation['guest'].key? 'id'
    assert_equal 'mary@gmail.com', reservation['guest']['email']
    assert_equal 'Mary', reservation['guest']['first_name']
    assert_equal 'Wilson', reservation['guest']['last_name']
    assert_equal '0413456789', reservation['guest']['phones'][0]['number']
  end

  test '#create should return unprocessable_entity if the payload format is unknown' do
    unrecognised_payload = {
      'name' => 'peaches',
      'score' => 99
    }

    assert_no_difference 'Reservation.count', 'no reservation should be created' do
      post reservations_url, params: unrecognised_payload, as: :json
    end

    assert_response :unprocessable_entity
  end

  test '#create should return unprocessable_entity the reservation is invalid' do
    # bad date
    bad_payload = {
      'reservation_code' => 'CODE-1234',
      'start_date' => 'not a date',
      'end_date' => '2021-04-18',
      'guest' => {
        'email' => 'new.guest@foo.bar.com',
        'first_name' => 'New',
        'last_name' => 'Guest'
      }
    }

    assert_no_difference 'Reservation.count', 'no reservation should be created' do
      post reservations_url, params: bad_payload, as: :json
    end

    assert_response :unprocessable_entity
    assert_equal '{"start_date":["can\'t be blank"]}', response.body
  end

  test '#create should return unprocessable_entity the guest is invalid' do
    # missing first and last name
    bad_payload = {
      'reservation_code' => 'CODE-2345',
      'start_date' => '2021-04-14',
      'end_date' => '2021-04-18',
      'guest' => {
        'email' => 'new.guest@foo.bar.com'
      }
    }

    assert_no_difference 'Reservation.count', 'no reservation should be created' do
      post reservations_url, params: bad_payload, as: :json
    end

    assert_response :unprocessable_entity
  end

  # test "should show reservation" do
  #   get reservation_url(@reservation), as: :json
  #   assert_response :success
  # end

  test 'should destroy reservation' do
    # not going to implement
    assert_raises ActionController::RoutingError do
      delete reservation_url(@reservation), as: :json
    end
  end
end
