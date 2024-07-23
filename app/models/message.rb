class Message < ApplicationRecord
  has_one :expense, dependent: :destroy

  validates_presence_of :body, :sender_name, :sender_phone, :timestamp
  after_create :create_expense

  private

  def create_expense
    message_processor = MessageProcessor.new(self)
    message_processor.call

    self.create_expense!(
      amount: message_processor.amount,
      description: message_processor.description,
      timestamp: message_processor.timestamp,
      group: message_processor.group
    )
  end
end
