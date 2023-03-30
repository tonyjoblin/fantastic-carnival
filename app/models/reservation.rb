# frozen_string_literal: true

class Reservation < ApplicationRecord
  belongs_to :guest, dependent: :destroy

  validates :code, :start_date, :end_date, :guest_id, presence: true
  validates :code, uniqueness: true
  validates :source, presence: true,
                     inclusion: { in: %w[xyz abc], message: I18n.t('reservations.validations.bad_data_source') }
end
