require 'walletone/signer'


describe Walletone::Signer do
  let(:secret_key) { '3475706857624f46344e573753316e387c396e5f4b54767b796c4c' }

  subject { described_class.new fields: fields }

  context '#sign' do
    describe 'variant1' do
      let(:fields) { Walletone::Fields.new(
                       WMI_MERCHANT_ID:    '127830694690',
                       WMI_PAYMENT_AMOUNT: '100.00',
                       WMI_PAYMENT_NO:     '123-45',
                       WMI_CURRENCY_ID:    '643',
                       WMI_DESCRIPTION:    'BASE64:cGF5bWVudCB0ZXN0',
                       WMI_EXPIRED_DATE:   '2019-12-31T23:59:59Z',
                       WMI_SUCCESS_URL:    'http://w1.artemeff.com/w1/success',
                       WMI_FAIL_URL:       'http://w1.artemeff.com/w1/fail'
      )}

      let(:signature) { 'uPmNH+YVl154kSH9hQdWNA==' }
      it { expect( subject.signature( secret_key ) ).to eq signature }
    end

    describe 'variant 2 (complex)' do
      let(:payment_types) { ['WebMoneyRUB', 'WebMoneyUSD'] }
      let(:fields) { Walletone::Fields.new({
        WMI_MERCHANT_ID:    127830694690,
        WMI_PAYMENT_AMOUNT: '100.00',
        WMI_CURRENCY_ID:    643,
        WMI_PTENABLED:      payment_types,
        foo:                ['bar', 'baz']
      }) }
      let(:signature) { 'BF737gCE9O3JOR5iqQF1kg==' }

      it { expect( subject.signature( secret_key ) ).to eq signature }
    end
  end

  #is_valid = response.valid?('0v/qXN0eonX2+8AuiLLONQ==', secret)
end
