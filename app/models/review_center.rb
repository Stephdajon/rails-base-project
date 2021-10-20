class ReviewCenter < ApplicationRecord
  has_many :rc_teachers, dependent: :destroy
  has_many :rc_courses, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, length: { maximum: 45 }
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 75 }
  validates :status, presence: true, on: :update
end
