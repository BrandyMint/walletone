# walletone checkout client for ruby

[![Build Status](https://travis-ci.org/BrandyMint/walletone.svg)](https://travis-ci.org/BrandyMint/walletone)
[![Code Climate](https://codeclimate.com/github/BrandyMint/walletone/badges/gpa.svg)](https://codeclimate.com/github/BrandyMint/walletone)

---


# Использование

## Прием уведомлений об оплате (rack middleware)

### 1. Создаем rack middleware для приема уведомлений

Сначала определимся как мы будем получать уведомление об оплате.

#### Вариант N1. Через callback

```ruby
wm = Walletone::Middleware::Callback.new do |notify, env|
  # notify is a Walletone::Notification instance

  raise 'Wrong sign' unless notify.valid? W1_SECRET_KEY

  # TODO something with notify

  'Return some message for OK response'
end
```

#### Вариант N2. Создаем свой класс middleware

```ruby
class MyApp::WalletoneMiddleware < Waletone::Middleware::Base
  def perform notify, env
    raise 'Wrong sign' unless notify.valid? W1_SECRET_KEY

    # TODO something with notify
    'Return some message for OK response'
  end
end

wm = MyApp::WalletoneMiddleware.new
```

### 2. Подключаем middleware

```ruby
# config.ru
run wm

# rails
mount wm => '/w1_callback'
```

### 3. Прописываем в walletone получившийся url

Готово. Принимаем уведомления.

## Генерация формы оплаты

### Сначала заполняем необходимые для формы поля

Поля хранятся в объекте типа `Walletone::Payment`, который представляет из 
себя `Hash` в возможностью прямого доступа к основным полям с префиксом `WMI_`.

Для полей требующих множественное значение (типа WMI_PTENABLED) в качестве
значений можно передавать массив строк.

```ruby
payment = Walletone::Payment.new(
    WMI_MERCHANT_ID:    'Номер вашего ID)',
    WMI_PAYMENT_AMOUNT:  10000, # Сумма
    WMI_CURRENCY_ID:     ISO номер валюты (По умолчанию 643 - Рубль),
    WMI_PTENABLED:      ['WebMoneyRUB', 'WebMoneyUSD'],
    SOME_CUSTOM_FIELD:  'value'
    # etc любые другие поля
)
```


### Собственно генераця формы

```haml
- form = Walletone::Form.new payment

%h5 В течение 5-и секунд вы будете переправлены на страницу оплаты.
= form_tag form.checkout_url, form.options.merge(data: {autosubmit: true}) do |f|
  = form.hidden_fields_tags
  = submit_tag 'Перейти к оплате', 
    :class=>'btn btn-primary',
    :data =>{:disable_with => 'Переправляю на сайт оплаты..'}

:coffee
  # Автоматически сабмитим форму, чтобы не тревожить лишний раз
  # пользователя
  $ -> $('[data-autosubmit]').submit()
```

# Прочие ссылки

1. [Walletone Open API](https://api.w1.ru/OpenApi/)
2. http://www.walletone.com/ru/merchant/documentation/

---

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
=======


## ТЗ

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

