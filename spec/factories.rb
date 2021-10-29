FactoryBot.define do
  factory :teacher do
    username { 'string' }
    firstname { 'string' }
    lastname { 'string' }
    email { 'user@email.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end

  factory :student do
    username { 'stringg' }
    firstname { 'stringg' }
    lastname { 'stringg' }
    email { 'userg@email.com' }
    password { 'password1' }
    password_confirmation { 'password1' }
  end

  factory :user do
    username { 'strings' }
    firstname { 'strings' }
    lastname { 'strings' }
    email { 'users@email.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end

  factory :review_center do
    email { 'rc@email.com' }
    name { 'string' }
    password { 'password' }
    password_confirmation { 'password' }
  end

  factory :course do
    name { 'String' }
  end

  factory :subject do
    name { 'String' }
    course
  end

  factory :rc_course do
    review_center
    course
  end

  factory :rc_teacher do
    status { 'approved' }
    review_center
  end

  factory :teacher_subject do
    rc_teacher
    rc_course
  end

  factory :lesson do
    name { 'String' }
    details { 'String' }
    price_cents { 100 }
    teacher_subject
    rc_course
  end

  factory :review do
    rating { 1 }
    comment { 'String' }
  end
end
