class User < ApplicationRecord
  # has_many :rc_teachers, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :username, :firstname, :lastname, :type, presence: true, length: { maximum: 20 }
  validates :username, uniqueness: { case_sensitive: false }, length: { maximum: 20 }
end
