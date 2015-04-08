module Walletone
  class Payment
    include Virtus.model

    attribute :WMI_MERCHANT_ID,    Integer, required: true
    attribute :WMI_PAYMENT_AMOUNT, Float,   required: true
    attribute :WMI_CURRENCY_ID,    Integer, required: true

    attribute :WMI_PAYMENT_NO
    attribute :WMI_DESCRIPTION,     String
    attribute :WMI_EXPIRED_DATE,    Time, default: nil
    attribute :WMI_RECIPIENT_LOGIN, String

    attribute :WMI_PTENABLED,  Array[String]
    attribute :WMI_PTDISABLED, Array[String]

    attribute :WMI_CUSTOMER_FIRSTNAME, String
    attribute :WMI_CUSTOMER_LASTNAME,  String
    attribute :WMI_CUSTOMER_EMAIL,     String

    attribute :WMI_SUCCESS_URL, String
    attribute :WMI_FAIL_URL,    String

    attribute :extra, Array


    def sign(secret: nil, hash_type: :md5)
      payment_presenter = PaymentPresenter.new(self)

      fields = format_attributes(payment_presenter)
      fields << sign_form(fields, secret, hash_type)

      Walletone.log(:info, "Sign Payment #{fields}")

      SignedPayment.new(fields)
    end

    def validate!
      # ...
    end

  private

    def format_attributes(presenter)
      attributes.inject([]) do |acc, kv|
        name, value = kv

        if value.is_a?(Array)
          acc + add_array_of_values(name, value)
        else
          acc << add_value(presenter, name, value)
        end
      end
    end

    def sign_form(fields, secret, hash_type)
      signer = Signer.new(fields, hash_type)
      ['WMI_SIGNATURE', signer.sign(secret)]
    end

    # Simply format values and add it
    def add_value(presenter, name, value)
      [name.to_s, presenter.send(name)]
    end

    # Adds array of values, like:
    #   [['foo', 'bar'], ['foo', 'baz']]
    # or
    #   ['WMI_PTENABLED', ['WebMoneyRUB', 'WebMoneyUSD']]
    # as
    #   ['foo', 'bar'], ['foo', 'baz'], ['WMI_PTENABLED', 'WebMoneyRUB'] ...
    def add_array_of_values(name, values)
      values.inject([]) do |acc, piece|
        if piece.is_a?(Array)
          acc << piece.map(&:to_s)
        else
          acc << [name.to_s, piece.to_s]
        end
      end
    end
  end
end
