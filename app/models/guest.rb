# frozen_string_literal: true

class Guest < ApplicationRecord
  has_many :phones, dependent: :destroy
  has_many :reservations, dependent: :destroy

  validates :email, :first_name, :last_name, presence: true
  validates :email, uniqueness: true
end
