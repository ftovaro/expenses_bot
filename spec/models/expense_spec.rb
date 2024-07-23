require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe 'valid' do
    it 'is valid with valid attributes' do
      expect(build(:expense)).to be_valid
    end
  end

  describe 'invalid' do
    it 'is invalid without an amount' do
      expect(build(:expense, amount: nil)).to_not be_valid
    end

    it 'is invalid without a description' do
      expect(build(:expense, description: nil)).to_not be_valid
    end

    it 'is invalid without a timestamp' do
      expect(build(:expense, timestamp: nil)).to_not be_valid
    end
  end

  describe 'associations' do
    it 'belongs to a message' do
      expect(Expense.reflect_on_association(:message).macro).to eq(:belongs_to)
    end
  end
end
