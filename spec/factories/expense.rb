FactoryBot.define do
  factory :expense do
    amount { 100.5 }
    description { 'Food' }
    timestamp { Time.now }
    group { 1 }
    message
  end
end
