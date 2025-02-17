require 'rails_helper'

RSpec.describe Tag, type: :model do
  context 'when validating presence' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
