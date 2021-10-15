class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :username, :firstname, :lastname, :password_confirmation, presence: true
  validates :username, uniqueness: true

  def admin?
    type == 'Admin'
  end

  def teacher?
    type == 'Teacher'
  end

  def student?
    type == 'Student'
  end
end
