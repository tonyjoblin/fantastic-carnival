# frozen_string_literal: true

require_relative '../../app/lib/hash_utils'

class HashUtilsTest < ActiveSupport::TestCase
  test 'has_key? returns true if the hash has the key' do
    h = {
      'a' => 5,
      'b' => {
        'c' => 6
      }
    }
    assert_equal true, HashUtils.key?(h, 'a')
    assert_equal true, HashUtils.key?(h, 'b.c')
    assert_equal false, HashUtils.key?(h, 'a.b.c')
    assert_equal false, HashUtils.key?(h, 'e')
  end

  test 'keys? returns true if the hash has all the keys' do
    h = {
      'a' => 5,
      'b' => {
        'c' => 6
      }
    }
    assert_equal true, HashUtils.keys?(h, ['a', 'b.c'])
    assert_equal false, HashUtils.keys?(h, %w[x a])
  end
end
