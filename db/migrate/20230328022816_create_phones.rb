class CreatePhones < ActiveRecord::Migration[7.0]
  def change
    create_table :phones do |t|
      t.string :number, null: false
      t.references :guest, null: false, foreign_key: true

      t.timestamps
    end
  end
end
