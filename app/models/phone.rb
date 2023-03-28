# frozen_string_literal: true

class Phone < ApplicationRecord
  belongs_to :guest, dependent: :destroy

  validates :number, presence: true
end
