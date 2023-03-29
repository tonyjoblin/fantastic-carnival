# frozen_string_literal: true

class AddSourceToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :source, :string

    # rubocop:disable Rails/SkipsModelValidations
    Reservation.update_all(source: 'xyz')
    # rubocop:enable Rails/SkipsModelValidations

    change_column_null :reservations, :source, false
  end
end
