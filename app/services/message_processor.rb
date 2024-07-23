class MessageProcessor
  attr_reader :amount, :description, :timestamp, :group

  def initialize(message)
    @message = message
  end

  def call
    process_message
  end

  private

  def process_message
    @amount, @description = extract_from_body
    @timestamp = extract_timestamp
    @group = extract_group
  end

  def extract_from_body
    body = @message.body
    amount_match = body.match(/(\d+(?:[.,]?\d{0,3})*)([kK\$]?)/)
    if amount_match
      amount_str, modifier = amount_match[1], amount_match[2]
      amount = parse_amount(amount_str, modifier)
      description = body.gsub(amount_match[0], '').strip.capitalize.gsub('$', '').strip
      [amount, description]
    else
      [nil, body.strip.capitalize]
    end
  end

  def parse_amount(amount_str, modifier)
    amount_str.gsub!(/[.,]/, '')
    amount = amount_str.to_i
    amount *= 1_000 if modifier.downcase == 'k'
    amount
  end

  def extract_timestamp
    @message.timestamp
  end

  def extract_group
    case @timestamp.day
    when 4..17
      2
    else
      1
    end
  end
end
