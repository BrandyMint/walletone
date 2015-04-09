Fabricator(:fields, from: 'Walletone::Fields') do
  WMI_MERCHANT_ID    { FFaker.numerify('############').to_i }
  WMI_CURRENCY_ID    { [643, 840, 978].sample }
  WMI_PAYMENT_AMOUNT { FFaker.numerify('##.##').to_f }
end

