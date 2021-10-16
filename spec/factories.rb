FactoryBot.define do
  factory :review_center do
    email { 'rc@email.com' }
    name { 'string' }
    password { 'password' }
  end

  factory :user do
    email { 'testsssst@student.com' }
    firstname { 'testt' }
    lastname { 'testt' }
    username { 'testt' }
    type { 'Student' }
    password { '123456' }
  end
end
