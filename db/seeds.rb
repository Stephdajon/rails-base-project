# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# USER 

User.create!([
  {
    email: "test@admin.com",
    username: "admin",
    firstname: "admin",
    lastname: "boardemy",
    type: 'Admin',
    status: 0,
    password: "123456",
    password_confirmation: "123456"
  },
  {
    email: "test@student.com",
    username: "student",
    firstname: "student",
    lastname: "boardemy",
    type: 'Student',
    status: 0,
    password: "123456",
    password_confirmation: "123456"
  },
  {
    email: "test@teacher.com",
    username: "teacher",
    firstname: "teacher",
    lastname: "boardemy",
    type: 'Teacher',
    status: 0,
    password: "123456",
    password_confirmation: "123456"
  }
])

# Review Center Users

ReviewCenter.create!([
  {
    email: "test@reviewcenter.com",
    name: "test review center",
    status: 'pending',
    password: "123456",
    password_confirmation: "123456"
  },
])

#RC COURSE 

RcCourse.create!([
  {
    review_center_id: 1,
    course_id: 1,
  }
])

# COURSE

Course.create!([
  {
    name: 'Software Engineer',
    status: 0
  }
])

RcTeacher.create!([
  {
    user_id: 1,
    review_center_id: 1
  }
])

# SUBJECT

Subject.create!([
  {
    name: 'Ruby on Rails',
    course_id: 1
    # status: 0
  }
])

# TEACHER SUBJECT

TeacherSubject.create!([
  {
    rc_teacher_id: 1,
    subject_id: 1
  }
])

# LESSON

Lesson.create!([
  {
    name: 'What is hash?',
    details: 'sample',
    teacher_subject_id: 1,
    rc_course_id: 1,
    price: 620
    # status: 0
  }
])

Lesson.create!([
  {
    name: 'Object Oriented Programming',
    details: 'sample',
    teacher_subject_id: 1,
    rc_course_id: 1,
    price: 560
    # status: 0
  }
])

Lesson.create!([
  {
    name: 'Ruby on Rails',
    details: 'sample',
    teacher_subject_id: 1,
    rc_course_id: 1,
    price: 590
    # status: 0
  }
])
