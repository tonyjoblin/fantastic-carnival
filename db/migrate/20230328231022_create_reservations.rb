# frozen_string_literal: true

class CreateReservations < ActiveRecord::Migration[7.0]
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def change
    create_table :reservations do |t|
      t.string :code, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :nights
      t.integer :guests
      t.integer :adults
      t.integer :children
      t.integer :infants
      t.string :status
      t.string :currency, limit: 3
      t.decimal :security_deposit, precision: 10, scale: 2
      t.decimal :payout_amount, precision: 10, scale: 2
      t.decimal :total_paid, precision: 10, scale: 2
      t.references :guest, null: false, foreign_key: true

      t.timestamps
    end
    add_index :reservations, :code, unique: true
    add_index :reservations, :start_date
    add_index :reservations, :status
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
