W1::PaymentService - Принимает уведомления об оплате (вызывается из rack-middleware)
W1::FormOptions - генератор формы -> Walletone::FormBuilder (Walletone::Payment)


## Отложено:

W1::RegistrationService - Сервис регистрации мерчанта
W1::OrderDeliveryService - Сервис для уведомления walleone о том, что нужно начать доставку
W1::OrderDeliveryUpdateService - Сервис, который дергает API walleotne чтобы узнать состояние заказа

Модуль для приема оплаты через Walletone

Основные функции:

1. Формирование платежной формы.
2. Прием ответных http-запросов о состоянии платежа.

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

