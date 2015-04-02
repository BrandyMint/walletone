module Walletone
  class Payment
    include Virtus.model

    # required
    attribute :merchant_id,    Integer
    attribute :payment_amount, Float
    attribute :currency_id,    Integer

    # optional
    attribute :payment_no
    attribute :description,     String
    attribute :expired_date,    Time, default: nil
    attribute :recipient_login, String

    attribute :pt_enabled,  Array[String]
    attribute :pt_disabled, Array[String]

    attribute :customer_firstname, String
    attribute :customer_lastname,  String
    attribute :customer_email,     String

    # extra fields
    attribute :extra, Array
  end
end
