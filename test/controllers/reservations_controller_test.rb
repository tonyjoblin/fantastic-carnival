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
    assert_equal '{"guest_id":["can\'t be blank"]}', response.body
  end

  # test "should show reservation" do
  #   get reservation_url(@reservation), as: :json
  #   assert_response :success
  # end

  # test "should update reservation" do
  #   patch reservation_url(@reservation), params: { reservation: {  } }, as: :json
  #   assert_response :success
  # end

  test 'should destroy reservation' do
    # not going to implement
    assert_raises ActionController::RoutingError do
      delete reservation_url(@reservation), as: :json
    end
  end
end
