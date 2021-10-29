require 'rails_helper'

RSpec.describe Review, type: :model do
  context 'when validating presence' do
    it { is_expected.to validate_presence_of(:rating) }
    it { is_expected.to validate_presence_of(:comment) }
  end

  context 'when validating associations' do
    it { is_expected.to belong_to(:lesson) }
    it { is_expected.to belong_to(:user) }
  end
end
