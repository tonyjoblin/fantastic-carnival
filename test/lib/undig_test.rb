# frozen_string_literal: true

require 'test_helper'
require 'undig'

class UndigTest < ActiveSupport::TestCase
  test "sets values in a hash" do
    h = {}
    assert_equal({ 'a' => 5 }, undig(h, 'a', 5))
    assert_equal({ 'a' => { 'b' => 6} }, undig(h, 'a', 'b', 6))
    assert_equal({ 'a' => { 'b' => 6 }, 'cat' => 'dog' }, undig(h, 'cat', 'dog'))
  end
end