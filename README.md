Модуль для приема оплаты через Walletone


## rack middleware

Прием информации о состоянии оплаты (SystemAPI/PaymentsCallback) и сервис PaymentService. При инициализации сервису передается env.
Сервис инициализируется глобально в конфигурации, ему передаются три параметра содержащие lambda-функции:

success
failed
invalid 

Если функция хочет сообщить об ошибке - она генерирует exception. В ином случае ее результат воспринимается как success.

При инициализации сервиса можно модставить свой вариант.

## Модели:

 W1::Order (virtus). Содержит все необходимые поля для генерации платежной формы.
 W1::Payment (virtus). Уведомление о платеже (используется в PaymentService)

## ViewHelpers:

payment_form_tag (W1::Order) - form_tag + hidden_fields

## Тесты:

rspec - 100%

