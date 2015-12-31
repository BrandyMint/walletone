# Базовый класс для полей формы и уведомления
#
module Walletone
  class Fields < Hash
    def self.define_fields(fields)
      # Определяем методы для прямого доступа
      # > payment.WMI_MERCHANT_ID
      # > payment.WMI_MERCHANT_ID=123
      #
      # > payment.WMI_PTENABLED =
      fields.each do |k|
        define_method k do
          fetch k
        end

        define_method "#{k}=" do |value|
          self[k] = value
        end
      end
    end

    def initialize(attrs = {})
      fields = super
      return fields if attrs.empty?
      symbolyzed_attrs = attrs.inject({}) { |acc, e| acc[e.first.to_sym] = e.last; acc }
      fields.merge! symbolyzed_attrs
    end

    def [](key)
      fetch key.to_sym, nil
    end

    def []=(key, value)
      super key.to_sym, value
    end

    def fetch(key, default = nil)
      super key.to_sym, default
    end

    def as_list
      keys.inject([]) do |acc, name|
        # Делаем именно так, чтобы работало переопределение методов
        # в Payment
        value = respond_to?(name) ? send(name) : fetch(name)
        Array(value).each { |v| acc << [name.to_s, v.to_s] }
        acc
      end
    end

    def to_s
      as_list.to_s
    end

    private

    def signer
      Signer.new fields: self
    end
  end
end
