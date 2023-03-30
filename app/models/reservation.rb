# frozen_string_literal: true

class Reservation < ApplicationRecord
  belongs_to :guest, dependent: :destroy

  before_save :sets_guest_count

  validates :code, :start_date, :end_date, :source, presence: true
  validates :code, uniqueness: true

  private

  def sets_guest_count
    if guests.blank? && (adults.present? || children.present? || infants.present?)
      self.guests = (adults || 0) + (children || 0) + (infants || 0)
    end
  end
end
