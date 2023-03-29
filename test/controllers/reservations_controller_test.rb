require "test_helper"

class ReservationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reservation = reservations(:one)
  end

  test "should get index" do
    # not implemented
    assert_raises ActionController::RoutingError do
      get reservations_url, as: :json
    end
  end

  test "should create reservation" do
    payload_json = file_fixture('reservations/xyz_new_reservation_for_mary.json').read
    payload_hash = JSON.parse(payload_json)

    assert_difference("Reservation.count") do
      post reservations_url, params: payload_hash, as: :json
    end

    assert_response :created
  end

  # TODO: test handling bad request

  # test "should show reservation" do
  #   get reservation_url(@reservation), as: :json
  #   assert_response :success
  # end

  # test "should update reservation" do
  #   patch reservation_url(@reservation), params: { reservation: {  } }, as: :json
  #   assert_response :success
  # end

  test "should destroy reservation" do
    # not going to implement
    assert_raises ActionController::RoutingError do
      delete reservation_url(@reservation), as: :json
    end
  end
end
