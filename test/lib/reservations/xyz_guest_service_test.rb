# frozen_string_literal: true

require 'test_helper'

class XyzGuestServiceTest < ActiveSupport::TestCase
  fixtures(:guests)

  test '#build_or_update returns a Guest' do
    result = Reservations::XyzGuestService.new.build_or_update({})
    assert_instance_of Guest, result
  end

  test '#build_or_update returns an existing guest' do
    payload_json = <<-JSON
      {
        "email":"steve@gmail.com"
      }
    JSON
    payload_hash = JSON.parse(payload_json)

    steve = guests(:steve)

    assert_no_difference 'Guest.count' do
      guest = Reservations::XyzGuestService.new.build_or_update(payload_hash)

      assert_equal steve.id, guest.id, 'Returns the existing guest record'
    end
  end

  test '#build_or_update missing fields dont erase existing values' do
    payload_json = <<-JSON
      {
        "email":"steve@gmail.com"
      }
    JSON
    payload_hash = JSON.parse(payload_json)

    guest = Reservations::XyzGuestService.new.build_or_update(payload_hash)

    assert_equal 'Steve', guest.first_name, 'Does not delete first_name'
    assert_equal 'Smith', guest.last_name, 'Does not delete last_name'
  end

  test '#build_or_update updates with new details' do
    payload_json = <<-JSON
      {
        "email":"new.guest@gmail.com",
        "first_name":"new first name",
        "last_name":"new last name"
      }
    JSON
    payload_hash = JSON.parse(payload_json)

    guest = Reservations::XyzGuestService.new.build_or_update(payload_hash)

    assert_equal 'new first name', guest.first_name
    assert_equal 'new last name', guest.last_name
  end

  test '#build_or_update can build a new guest' do
    payload_json = <<-JSON
      {
        "email":"new.guest@gmail.com",
        "first_name":"New",
        "last_name":"Guest",
        "phone": "639123456789"
      }
    JSON
    payload_hash = JSON.parse(payload_json)

    assert_difference 'Guest.count', 1, 'Creates a reservation' do
      guest = Reservations::XyzGuestService.new.build_or_update(payload_hash)

      assert guest.id.present?, 'Has been saved to db'
      assert_equal 'new.guest@gmail.com', guest.email, 'Sets the email'
      assert_equal 'New', guest.first_name, 'Sets the first name'
      assert_equal 'Guest', guest.last_name, 'Sets the last name'
    end
  end

  # TODO: tests for updating/setting phone numbers
end
