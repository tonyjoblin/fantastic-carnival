# frozen_string_literal: true

class Phone < ApplicationRecord
  belongs_to :guest

  validates :number, presence: true
end
