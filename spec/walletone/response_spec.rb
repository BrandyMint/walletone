describe Walletone::Response do
  let(:secret) { '623577687055676e43446f6c474f385165356e64556e474e5d7366' }
  let(:raw_params) do
    {
      'WMI_MERCHANT_ID'         => '127696943127',
      'WMI_CURRENCY_ID'         => '643',
      'WMI_PAYMENT_AMOUNT'      => '3000.00',
      'WMI_AUTO_ACCEPT'         => '1',
      'WMI_COMMISSION_AMOUNT'   => '120.00',
      'WMI_CREATE_DATE'         => '2014-12-16 20:04:27',
      'WMI_DESCRIPTION'         => 'Браслет цепочка Хамса с цирконами золоченый',
      'WMI_EXPIRED_DATE'        => '2015-01-16 20:04:27',
      'WMI_EXTERNAL_ACCOUNT_ID' => '4276********3093',
      'WMI_LAST_NOTIFY_DATE'    => '2014-12-16 20:07:44',
      'WMI_NOTIFY_COUNT'        => '3',
      'WMI_ORDER_ID'            => '346935973926',
      'WMI_ORDER_STATE'         => 'Accepted',
      'WMI_PAYMENT_NO'          => 'kiosk:5-604-pro',
      'WMI_PAYMENT_TYPE'        => 'CreditCardRUB',
      'WMI_FAIL_URL'            => 'http://wannabe.kiiiosk.ru/payments/w1/failure',
      'WMI_SUCCESS_URL'         => 'http://wannabe.kiiiosk.ru/payments/w1/success',
      'WMI_UPDATE_DATE'         => '2014-12-16 20:05:51',
      'WMI_SIGNATURE'           => '0v/qXN0eonX2+8AuiLLONQ=='
    }
  end

  context '#valid?' do
    it 'compare signatures from request and response' do
      response = described_class.new(raw_params)
      is_valid = response.valid?('0v/qXN0eonX2+8AuiLLONQ==', secret)
      expect(is_valid).to be_truthy
    end
  end
end
