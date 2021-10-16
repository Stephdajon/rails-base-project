require 'rails_helper'

RSpec.describe Teacher, type: :model do
  context 'when validating associations' do
    it { is_expected.to have_many(:rc_teachers) }
  end
end
