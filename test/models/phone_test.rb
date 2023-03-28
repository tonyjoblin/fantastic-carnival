require "test_helper"

class PhoneTest < ActiveSupport::TestCase
  test "required fields must be present" do
    phone = Phone.new

    assert phone.invalid?, "Required fields must be present"
    assert phone.errors[:number].any?, "The phone number field must be present"
    assert phone.errors[:guest].any?, "The phone number must belong to a guest"

    phone.number = '0411123567'
    steve = guests(:steve)
    phone.guest = steve

    assert phone.valid?, "A phone that has the required fields is valid"
  end
end
