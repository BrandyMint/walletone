module Walletone
  class Form
    attr_reader :fields

    def initialize(form_builder)
      raise ArgumentError unless form_builder.is_a?(FormBuilder)

      @fields = form_builder.fields.map do |key, value|
        [key.upcase, value]
      end
    end
  end
end
