class Phone < ApplicationRecord
  belongs_to :guest

  validates :guest, :number, presence: true
end
