#!/usr/bin/env ruby

require 'pry'
require 'walletone'
require 'walletone/invoicing'

require 'money'

api = Walletone::Invoicing::Client.new(user_id: ENV['USER_ID'], secret_key: ENV['SECRET_KEY'])

amount = Money.new 1000, 'rub'

invoice = api.make_invoice amount: amount, order_id: 'test1'

api.make_payments_process payment_id: invoice['Invoice']['Payment']['PaymentId'], phone: '79033891228' # , customer_id: 'testuser1'

puts "[#{response.code}] #{response.body}"
