require 'rails_helper'

RSpec.describe User, type: :model do
  context 'when validating presence' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:firstname) }
    it { is_expected.to validate_presence_of(:lastname) }
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:type) }
  end

  context 'when validating maximum character length' do
    it { is_expected.to validate_length_of(:firstname).is_at_most(75) }
    it { is_expected.to validate_length_of(:lastname).is_at_most(75) }
    it { is_expected.to validate_length_of(:username).is_at_most(75) }
    it { is_expected.to validate_length_of(:type).is_at_most(75) }
  end

  context 'when validating uniqueness' do
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
  end
end
