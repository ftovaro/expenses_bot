class Message < ApplicationRecord
  has_one :expense

  validates_presence_of :body, :sender_name, :sender_phone, :timestamp
end
