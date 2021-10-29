class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :lessons, through: :taggings

  validates :name, presence: true
end
