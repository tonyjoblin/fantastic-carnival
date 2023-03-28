require "test_helper"

class GuestTest < ActiveSupport::TestCase
  fixtures :guests

  test "the required fields must be present" do
    guest = Guest.new

    assert guest.invalid?, "The new guest should be invalid"
    assert guest.errors[:email].any?, "The guest must have an email"
    assert guest.errors[:first_name].any?, "The guest must have a first name"
    assert guest.errors[:last_name].any?, "The guest must have a last name"

    guest.email = 'tom@acme.com.au'
    guest.first_name = 'Tom'
    guest.last_name = 'Johnson'

    assert guest.valid?, "The guest should be valid"
  end

  test "guest email must be unique" do
    assert_equal(
      1,
      Guest.where(email: 'steve@gmail.com').count,
      "Precondition: there should already be a guest with email steve@gmail.com"
    )

    new_guest = Guest.new(email: 'steve@gmail.com', first_name: 'Steve', last_name: 'Walker')

    assert new_guest.invalid?, "You cannot add another guest with email steve@gmail.com"
    assert new_guest.errors[:email].any?
  end
end
