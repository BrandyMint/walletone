### walletone

---

### Usage

Define your callback:

```ruby
Walletone.notify_callback = lambda do |response, rack_env|
  if response.valid?(our_signature, secret, hash_type)
    # do there what you want with `response.params`
    response.ok
  else
    response.retry('Wrong sign')
  end
end
```

And mount it in your application:

```ruby
# config.ru
run Walletone::NotifyCallback.new

# rails
mount Walletone::NotifyCallback.new => '/w1_callback'
```

---

### Useful links

1. [Walletone Open API](https://api.w1.ru/OpenApi/)

---

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
