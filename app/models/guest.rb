class Guest < ApplicationRecord
  validates :email, :first_name, :last_name, presence: true
  validates :email, uniqueness: true
end
