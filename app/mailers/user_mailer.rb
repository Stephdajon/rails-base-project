class UserMailer < ApplicationMailer
  def welcome_email(student)
    @student = student
    mail(
      to: student.email,
      subject: 'Welcome to Go Learning Academy.'
    )
  end

  def confirmation_email(student)
    @student = student
    mail(
      to: student.email,
      subject: 'Welcome to Go Learning Academy.'
    )
  end
end
