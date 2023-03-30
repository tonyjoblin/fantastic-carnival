# frozen_string_literal: true

require 'test_helper'
require_relative '../../app/lib/hash_utils'

class TransformHashTest < ActiveSupport::TestCase
  test 'does simple key transformations' do
    original_hash = {
      'a' => 5
    }

    assert_equal({ 'b' => 5 }, HashUtils.transform_hash(original_hash, { 'a' => 'b' }))
  end

  test 'the transform parameter can be an array of key value pair' do
    original_hash = {
      'a' => 5
    }

    assert_equal({ 'b' => 5 }, HashUtils.transform_hash(original_hash, [%w[a b]]))
  end

  test 'ignores anything that is not in the white list' do
    original_hash = {
      'a' => 5,
      'c' => 6
    }

    assert_equal({ 'b' => 5 }, HashUtils.transform_hash(original_hash, { 'a' => 'b' }))
  end

  test 'if a key in the whitelist does not exist in the hash nothing is written to the output hash' do
    original_hash = {}

    assert_equal({}, HashUtils.transform_hash(original_hash, { 'a' => 'b' }))
  end

  test 'handles nested hashes' do
    original_hash = {
      'a' => {
        'b' => 5
      },
      'c' => 6,
      'd' => {
        'e' => 9,
        'f' => 12
      }
    }

    assert_equal(
      {
        'cat' => 5,
        'dog' => {
          'pony' => 6
        },
        'object' => {
          'e' => 9,
          'f' => 12
        }
      },
      HashUtils.transform_hash(original_hash, { 'a.b' => 'cat', 'c' => 'dog.pony', 'd' => 'object' })
    )
  end

  test 'works with ActionController::Parameters' do
    json = file_fixture('reservations/abc_reservation_payload.json').read
    params = ActionController::Parameters.new(JSON.parse(json))

    assert_equal(
      {
        'code' => 'XXX12345678',
        'adults' => 2
      },
      HashUtils.transform_hash(params,
                               { 'reservation.code' => 'code',
                                 'reservation.guest_details.number_of_adults' => 'adults' })
    )
  end
end
