require 'rails_helper'

RSpec.describe Lesson, type: :model do
  context 'when validating presence' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_presence_of(:video) }
    it { is_expected.to validate_presence_of(:thumbnail) }
  end

  context 'when validating associations' do
    it { is_expected.to belong_to(:rc_course) }
    it { is_expected.to belong_to(:teacher_subject) }
  end

  context 'when attachements' do
    it { is_expected.to have_one_attached(:video) }
    it { is_expected.to have_one_attached(:thumbnail) }
  end
end
