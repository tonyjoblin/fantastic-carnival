# frozen_string_literal: true

require_relative '../../app/lib/hash_utils'

class HashUtilsTest < ActiveSupport::TestCase
  test "has_key? returns true if the hash has the key" do
    h = {
      'a' => 5,
      'b' => {
        'c'=> 6
      }
    }
    assert_equal true, HashUtils.has_key?(h, 'a')
    assert_equal true, HashUtils.has_key?(h, 'b.c')
    assert_equal false, HashUtils.has_key?(h, 'a.b.c')
    assert_equal false, HashUtils.has_key?(h, 'e')
  end

  test "has_keys? returns true if the hash has all the keys" do
    h = {
      'a' => 5,
      'b' => {
        'c'=> 6
      }
    }
    assert_equal true, HashUtils.has_keys?(h, ['a', 'b.c'])
    assert_equal false, HashUtils.has_keys?(h, ['x', 'a'])
  end
end
