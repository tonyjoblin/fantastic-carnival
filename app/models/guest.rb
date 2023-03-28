class Guest < ApplicationRecord
  has_many :phones

  validates :email, :first_name, :last_name, presence: true
  validates :email, uniqueness: true
end
