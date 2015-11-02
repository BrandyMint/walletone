module Walletone::Recurrent
  class Invoice
    include Virtus.model strict: true, coerce: false

    attribute :Amount,                  Float,   required: true
    attribute :OrderId,                 String,  required: true
    attribute :InvoiceAdditionalParams, Hash
    attribute :CurrencyId,              Integer, required: true, default: 643 # rub
    attribute :PaymentTimeId,           String,  required: true, default: 'CreditCardRUB'
  end
end
