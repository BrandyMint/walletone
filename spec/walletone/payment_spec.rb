describe Walletone::Payment do
  let(:merchant_id) { 127830694690 }
  let(:secret) { '3475706857624f46344e573753316e387c396e5f4b54767b796c4c' }

  context '.new' do
    it 'works' do
      payment = described_class.new(WMI_MERCHANT_ID: merchant_id)
      expect(payment.WMI_MERCHANT_ID).to eq(merchant_id)
    end
  end

  context '#sign' do
    it 'simple payment' do
      payment = described_class.new({
        WMI_MERCHANT_ID:    127830694690,
        WMI_PAYMENT_AMOUNT: 100.00,
        WMI_PAYMENT_NO:     '123-45',
        WMI_CURRENCY_ID:    643,
        WMI_DESCRIPTION:    'payment test',
        WMI_EXPIRED_DATE:   Time.new(2019, 12, 31, 23, 59, 59, "+00:00").utc,
        WMI_SUCCESS_URL:    'http://w1.artemeff.com/w1/success',
        WMI_FAIL_URL:       'http://w1.artemeff.com/w1/fail'
      })
      signed = payment.sign(secret: secret)
      signature = signed['WMI_SIGNATURE']
      expect(signed).to be_a(Walletone::SignedPayment)
      expect(signature).to eq(['uPmNH+YVl154kSH9hQdWNA=='])
    end

    it 'complex payment' do
      payment_types = ['WebMoneyRUB', 'WebMoneyUSD']
      payment = described_class.new({
        WMI_MERCHANT_ID:    127830694690,
        WMI_PAYMENT_AMOUNT: 100.00,
        WMI_CURRENCY_ID:    643,
        WMI_PTENABLED:      payment_types,
        extra:              [['foo', 'bar'], ['foo', 'baz']]
      })
      signed = payment.sign(secret: secret)
      signature = signed['WMI_SIGNATURE']
      expect(signed).to be_a(Walletone::SignedPayment)
      expect(signed['foo']).to eq(['bar', 'baz'])
      expect(signed['WMI_PTENABLED']).to eq(payment_types)
      expect(signature).to eq(['BF737gCE9O3JOR5iqQF1kg=='])
    end

    context 'format' do
      it 'WMI_PAYMENT_AMOUNT' do
        payment = Fabricate(:payment, {WMI_PAYMENT_AMOUNT: 1.2})
        signed  = payment.sign(secret: secret)
        expect(signed['WMI_PAYMENT_AMOUNT'].first).to eq('1.20')
      end

      it 'WMI_DESCRIPTION as base64' do
        payment = Fabricate(:payment, {WMI_DESCRIPTION: 'test'})
        signed  = payment.sign(secret: secret)
        expect(signed['WMI_DESCRIPTION'].first).to eq('BASE64:dGVzdA==')
      end

      it 'WMI_DESCRIPTION reduces to 250 symbols' do
        description = FFaker::Lorem.sentence(128)
        payment = Fabricate(:payment, {WMI_DESCRIPTION: description})
        signed  = payment.sign(secret: secret)
        text = Base64.decode64(signed['WMI_DESCRIPTION'].first)
        expect(text.size).to eq(255)
      end

      it 'WMI_EXPIRED_DATE as ISO8601' do
        date = Time.new(2015, 4, 1, 12, 00, 00)
        payment = Fabricate(:payment, {WMI_EXPIRED_DATE: date})
        signed  = payment.sign(secret: secret)
        expect(signed['WMI_EXPIRED_DATE'].first).to eq('2015-04-01T12:00:00+03:00')
      end
    end
  end

  context '#validate!' do
    pending
  end
end
