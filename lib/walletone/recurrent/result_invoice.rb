module Walletone::Recurrent
  class ResultInvoice
    class InvoiceInfo
      RAW_EXAMPLE =
        { 'Invoice' => { 'InvoiceId' => 345_539_868_062,
                         'Amount' => 1.24,
                         'CurrencyId' => 643,
                         'InvoiceStateId' => 'Created',
                         'CreateDate' => '2015-12-31T08:20:13',
                         'UpdateDate' => '2015-12-31T08:20:13',
                         'Payment' => { 'PaymentId' => 69_904_496,
                                        'PaymentCode' => '345539868062',
                                        'PaymentCodeType' => 'InvoiceId',
                                        'CreateDate' => '2015-12-31T08:20:14.137',
                                        'UpdateDate' => '2015-12-31T08:20:14.137',
                                        'PaymentStateId' => 'Created',
                                        'PaymentTypeId' => 'CreditCardRUB' } },
          'CanSaveAsExternalAccount' => true }

      class PaymentInfo
        include Virtus.model strict: true

        attribute :PaymentId,       Integer
        attribute :PaymentCode,     String
        attribute :PaymentCodeType, String # 'InvoiceId'
        attribute :CreateDate,      Time
        attribute :UpdateDate,      Time
        attribute :PaymentStateId, String # 'Created'
        # Состояние платежа в ответе на запрос подтверждения списания средств. Может принимать одно из следующих состояний:
        # Paid — списание произошло успешно.
        # Error — произошла ошибка
        # Created — создан, оплата не поступала
        # Processing — в обработке
        attribute :PaymentTypeId, String # 'CreditCardRUB'
      end

      include Virtus.model strict: true

      attribute :InvoiceId,      Integer
      attribute :Amount,         Float
      attribute :InvoiceStateId, String # 'Created'
      # Параметр “InvoiceStateId”
      # Сосотяние выставленного счета в ответе на создание счета. Может принимать одно из следующих значений:
      # Created — счет успешно создан.
      # Canceled — отменен
      # Accepted — оплачен
      # Expired — вышел срок действия
      # Processing — в процессе подтверждения
      # Received — получен, ожидает принятия
      # Rejected — отвергнут
      # PartiallyPaid — частично оплачен
      # OverPaid — переплачен
      attribute :CreateDate,     Time
      attribute :UpdateDate,     Time
      attribute :Payment,        PaymentInfo
    end

    include Virtus.model strict: true

    attribute :Invoice,                  InvoiceInfo, required: true
    attribute :CanSaveAsExternalAccount, Boolean
  end
end
