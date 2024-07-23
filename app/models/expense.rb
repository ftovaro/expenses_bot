class Expense < ApplicationRecord
  belongs_to :message

  validates_presence_of :amount, :description, :timestamp

  enum group: { group_1: 1, group_2: 2 }
end
