class W1::PaymentService::Error < StandardError
  def initialize payment
    @payment = payment
  end

  def message
    "Платеж не прошел"
  end

  def inspect
    @payment
  end
end

