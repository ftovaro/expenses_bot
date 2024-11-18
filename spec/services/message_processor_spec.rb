require 'rails_helper'

RSpec.describe MessageProcessor do
  describe '#call' do
    describe 'body' do
      # Currency for the tests is COP
      let(:message_price_with_point) { build(:message, body: '105.400 Lunch') }
      let(:message_price_with_k) { build(:message, body: 'Party with friend 200k') }
      let(:message_price_full_price) { build(:message, body: '250600 dinner with mom') }
      let(:message_price_with_sign) { build(:message, body: 'Coffee Maker $70.560') }
      let(:message_price_with_sign_and_k) { build(:message, body: 'Breakfast $50k') }
      let(:message_no_price) { build(:message, body: 'Breakfast') }

      it 'processes a message with amount and description' do
        message_processor = MessageProcessor.new(message_price_with_point)

        message_processor.call

        expect(message_processor.amount).to eq(105_400)
        expect(message_processor.description).to eq('Lunch')
      end

      it 'processes a message with amount in k' do
        message_processor = MessageProcessor.new(message_price_with_k)

        message_processor.call

        expect(message_processor.amount).to eq(200_000)
        expect(message_processor.description).to eq('Party with friend')
      end

      it 'processes a message with amount and description clean' do
        message_processor = MessageProcessor.new(message_price_full_price)

        message_processor.call

        expect(message_processor.amount).to eq(250_600)
        expect(message_processor.description).to eq('Dinner with mom')
      end

      it 'processes a message with amount in $' do
        message_processor = MessageProcessor.new(message_price_with_sign)

        message_processor.call

        expect(message_processor.amount).to eq(70_560)
        expect(message_processor.description).to eq('Coffee maker')
      end

      it 'processes a message with amount and description in k and $' do
        message_processor = MessageProcessor.new(message_price_with_sign_and_k)

        message_processor.call

        expect(message_processor.amount).to eq(50_000)
        expect(message_processor.description).to eq('Breakfast')
      end

      it 'processes a message without a price in body' do
        message_processor = MessageProcessor.new(message_no_price)

        message_processor.call

        expect(message_processor.amount).to eq(nil)
        expect(message_processor.description).to eq('Breakfast')
      end
    end

    describe 'timestamp' do
      let(:message) { build(:message, timestamp: Time.parse('25/11/2023 14:25')) }
      it 'processes a message with timestamp' do
        message_processor = MessageProcessor.new(message)

        message_processor.call

        expect(message_processor.timestamp).to eq(Time.parse('25/11/2023 14:25'))
      end
    end

    describe 'group' do
      let(:message_group_1) { build(:message, timestamp: Date.parse('03/05/2024')) }
      let(:message_group_2) { build(:message, timestamp: Date.parse('17/05/2024')) }

      it 'processes a message for group 1' do
        message_processor = MessageProcessor.new(message_group_1)

        message_processor.call

        expect(message_processor.group).to eq(1)
      end

      xit 'processes a message for group 2' do
        message_processor = MessageProcessor.new(message_group_2)

        message_processor.call

        expect(message_processor.group).to eq(2)
      end
    end
  end
end
