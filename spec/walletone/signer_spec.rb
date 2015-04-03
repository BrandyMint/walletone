describe Walletone::Signer do
  let(:secret) { '3475706857624f46344e573753316e387c396e5f4b54767b796c4c' }

  context '#sign' do
    it 'sign fields in simple form' do
      fields = {
        WMI_MERCHANT_ID:    '127830694690',
        WMI_PAYMENT_AMOUNT: '100.00',
        WMI_PAYMENT_NO:     '123-45',
        WMI_CURRENCY_ID:    '643',
        WMI_DESCRIPTION:    'BASE64:cGF5bWVudCB0ZXN0',
        WMI_EXPIRED_DATE:   '2019-12-31T23:59:59Z',
        WMI_SUCCESS_URL:    'http://w1.artemeff.com/w1/success',
        WMI_FAIL_URL:       'http://w1.artemeff.com/w1/fail'
      }
      signer = described_class.new(fields)
      signature = signer.sign(secret)
      expect(signature).to eq('uPmNH+YVl154kSH9hQdWNA==')
    end
  end
end
