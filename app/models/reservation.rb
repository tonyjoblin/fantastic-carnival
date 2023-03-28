class Reservation < ApplicationRecord
  belongs_to :guest, dependent: :destroy

  validates :code, :start_date, :end_date, :guest, presence: true
  validates :code, uniqueness: true
end
