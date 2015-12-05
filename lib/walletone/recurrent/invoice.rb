module Walletone::Recurrent
  class Invoice
    include Virtus.model strict: true, coerce: false

    attribute :OrderId,                 String,  required: true
    attribute :Amount,                  Float,   required: true
    attribute :CurrencyId,              Integer, required: true, default: 643 # rub
    attribute :PaymentTypeId,           String,  required: true, default: 'CreditCardRUB' #  MtsRUB, MegafonRUB, Tele2RUB, BeelineRUB
    attribute :InvoiceAdditionalParams, Hash
  end
end
