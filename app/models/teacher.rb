class Teacher < User
  has_many :rc_teachers, foreign_key: 'user_id', dependent: :destroy, inverse_of: :teacher
end
