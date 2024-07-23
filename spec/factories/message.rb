FactoryBot.define do
  factory :message do
    sender_name { 'John Doe' }
    sender_phone { '09123456789' }
    body { 'Hello, World!' }
    timestamp { Time.now }
    soft_deleted { false }
  end
end
