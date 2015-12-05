# walletone checkout client for ruby

[![Build Status](https://travis-ci.org/BrandyMint/walletone.svg)](https://travis-ci.org/BrandyMint/walletone)
[![Code Climate](https://codeclimate.com/github/BrandyMint/walletone/badges/gpa.svg)](https://codeclimate.com/github/BrandyMint/walletone)
[![Test
Coverage](https://codeclimate.com/github/BrandyMint/walletone/badges/coverage.svg)](https://codeclimate.com/github/BrandyMint/walletone)

---

Привет!

Мы сделали этот модуль очень удобным для Вас. Вы сделаете нам приятно и полезно,
если зарегистрируете своего мерчанта по [этой промо-ссылке](http://www.walletone.com/ru/merchant/?promo=EtRa48zZP)

Так вы получите сниженный процент за прием платежей по картам visa/mastercard - 3,5%

## Прием уведомлений об оплате (rack middleware)

### 1. Создаем rack middleware для приема уведомлений

Сначала определимся как мы будем получать уведомление об оплате.

#### Вариант N1. Через callback

```ruby
wm = Walletone::Middleware::Callback.new do |notify, env|
  # notify is a Walletone::Notification instance

  raise 'WARNING! Wrong signature!' unless notify.valid? W1_SECRET_KEY

  if notify.accepted?
    # Successful payed. Deliver your goods to the client
  else
    # Payment is failed. Notify you client.
  end

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

### 3. Прописываем в настройках мерчанта на walletone.com получившийся url

Готово. Принимаем уведомления.

## Генерация формы оплаты

### Сначала заполняем необходимые для формы поля

Поля хранятся в объекте типа `Walletone::Payment`, который представляет из 
себя `Hash` с возможностью прямого доступа к основным полям с префиксом `WMI_`.

Для полей требующих множественное значение (типа `WMI_PTENABLED`) в качестве
значений можно передавать массив строк.

```ruby
payment = Walletone::Payment.new(
    WMI_MERCHANT_ID:    'Номер вашего merchant ID',
    WMI_PAYMENT_AMOUNT:  10000, # Сумма
    WMI_CURRENCY_ID:     643, # ISO номер валюты (По умолчанию 643 - Рубль),
    WMI_PTENABLED:      ['WebMoneyRUB', 'WebMoneyUSD'],
    SOME_CUSTOM_FIELD:  'value'
    # etc любые другие поля
)
payment.sign! 'you secret key'
form = payment.form
```


### Собственно генераця формы

```haml

%h5 В течение 5-и секунд вы будете переправлены на страницу оплаты.
= form_tag form.checkout_url, form.options.merge(data: {autosubmit: true}) do |f|
  = raw form.hidden_fields_tags
  = button_tag 'Перейти к оплате', 
    :class=>'btn btn-primary',
    :data =>{:disable_with => 'Переправляю на сайт оплаты..'}

:coffee
  # Автоматически сабмитим форму, чтобы не тревожить лишний раз
  # пользователя
  $ -> $('[data-autosubmit]').submit()
```

# Подсказки

Не используйте в форме кнопку `submit` с установленным `value` и `name`, потому что в
таком случае ее значение на сервер придет в параметрах и его тоже придется
включать в подписываемые поля.

# Прочие ссылки

1. [Walletone Open API](https://api.w1.ru/OpenApi/)
2. [Документация (API)](http://www.walletone.com/ru/merchant/documentation/)
3. [Доставка redexpress](http://www.walletone.com/en/merchant/delivery/about/)
4. [Рекуренты](https://docs.google.com/document/d/1_1HponT9Xv5dJ10Lqh23JyNGhqhNq9myb4xXl-gUOCI/pub?embedded=true)
5.
[InvoicingAPI](https://docs.google.com/document/d/18YaYbAwHo5jKCx88ox3okj1RJqcPF_2gSDdzpK2XHDI/pub?embedded=true)

Sponsored by http://taaasty.com and http://kiiiosk.ru
Developers are http://brandymint.com

---

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

