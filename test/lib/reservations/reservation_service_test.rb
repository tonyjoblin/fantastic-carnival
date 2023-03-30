# frozen_string_literal: true

require 'test_helper'

class ReservationServiceImpl < Reservations::ReservationService
  def required_keys
    %w[a b.c]
  end
end

class ReservationServiceTest < ActiveSupport::TestCase
  fixtures :reservations

  test '#accepts? returns true if it can parse the payload' do
    service = ReservationServiceImpl.new
    assert service.accepts?('a' => 5, 'b' => { 'c' => 7 }, 'd' => 'cat'),
           'Accepted, all required attributes present'
    assert_equal false, service.accepts?('b' => { 'c' => 7 }, 'd' => 'cat'),
                 'Not accepted, attribute \'a\' is missing'
  end
end
