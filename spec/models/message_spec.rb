require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'valid' do
    it 'is valid with valid attributes' do
      expect(build(:message)).to be_valid
    end
  end

  describe 'invalid' do
    it 'is invalid without a body' do
      expect(build(:message, body: nil)).to_not be_valid
    end

    it 'is invalid without a sender_name' do
      expect(build(:message, sender_name: nil)).to_not be_valid
    end

    it 'is invalid without a sender_phone' do
      expect(build(:message, sender_phone: nil)).to_not be_valid
    end

    it 'is invalid without a timestamp' do
      expect(build(:message, timestamp: nil)).to_not be_valid
    end
  end

  describe 'associations' do
    it 'has one expense' do
      expect(Message.reflect_on_association(:expense).macro).to eq(:has_one)
    end

    it 'destroys associated expense' do
      message = create(:message)

      message.destroy

      expect(Expense.count).to eq(0)
    end

    it 'creates associated expense' do
      create(:message)

      expect(Expense.count).to eq(1)
    end
  end
end
