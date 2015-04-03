module Walletone
  class SignedPayment
    attr_reader :fields

    def initialize(fields)
      @fields = list_to_tuples(fields)
    end

    def [](name)
      @fields.select { |o| o.key == name.to_s }.map(&:value)
    end

  private

    def list_to_tuples(fields)
      fields.map do |k, v|
        Tuple.new(k, v)
      end
    end
  end
end
