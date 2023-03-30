# frozen_string_literal: true

require_relative '../../app/lib/hash_utils'

class UndigTest < ActiveSupport::TestCase
  test 'sets values in a hash' do
    h = {}
    assert_equal({ 'a' => 5 }, HashUtils.undig(h, 'a', 5))
    assert_equal({ 'a' => { 'b' => 6 } }, HashUtils.undig(h, 'a', 'b', 6))
    assert_equal({ 'a' => { 'b' => 6 }, 'cat' => 'dog' }, HashUtils.undig(h, 'cat', 'dog'))
  end
end
