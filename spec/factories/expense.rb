FactoryBot.define do
  factory :expense do
    amount { 100.5 }
    description { 'Food' }
    timestamp { Time.now }
    group { 0 }
    message
  end
end
