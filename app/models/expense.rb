class Expense < ApplicationRecord
  belongs_to :message, dependent: :destroy

  validates_presence_of :amount, :description, :timestamp
end
