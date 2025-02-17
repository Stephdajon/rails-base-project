require 'rails_helper'

RSpec.describe TeacherSubject, type: :model do
  context 'when validating associations' do
    it { is_expected.to belong_to(:rc_teacher) }
    it { is_expected.to belong_to(:subject) }
    it { is_expected.to belong_to(:rc_course) }
    it { is_expected.to have_many(:lessons) }
  end
end
