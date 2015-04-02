Fabricator(:payment, from: 'Walletone::Payment') do
  merchant_id    { FFaker.numerify('############').to_i }
  currency_id    { [643, 840, 978].sample }
  payment_amount { FFaker.numerify('##.##').to_f }
end
