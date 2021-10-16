class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :username, :firstname, :lastname, :password_confirmation, :type, presence: true, length: { maximum: 25 }
  validates :username, uniqueness: { case_sensitive: false }, length: { maximum: 20 }

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
