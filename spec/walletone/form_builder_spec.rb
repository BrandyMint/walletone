describe Walletone::FormBuilder do
  context '.initialize' do
    it 'add fields from payment object' do
      builder = described_class.new(Fabricate(:payment))
      expect(builder.fields.size).to be > 0
    end

    it 'add extra fields' do
      payment = Fabricate(:payment, extra:
        [[:foo, 'bar'], [:foo, 'baz']])
      builder = described_class.new(payment)
      expect(builder.get_field('foo')).to eq(['bar', 'baz'])
    end

    it 'throws error when try to pass other objects' do
      expect { described_class.new([]) }.to raise_error(ArgumentError)
    end
  end

  context '#generate_signature' do
    it 'with valid payment object' do
      secret  = '3475706857624f46344e573753316e387c396e5f4b54767b796c4c'
      payment = Fabricate(:payment, {
        merchant_id:    127830694690,
        payment_amount: 100.00,
        payment_no:     '123-45',
        currency_id:    643,
        description:    'payment test',
        expired_date:   Time.new(2019, 12, 31, 23, 59, 59, "+00:00").utc
      })
      builder = described_class.new(payment, {
        wmi_success_url: 'http://w1.artemeff.com/w1/success',
        wmi_fail_url: 'http://w1.artemeff.com/w1/fail'
      })
      builder.generate_signature(secret)
      signature = builder.get_field('wmi_signature')
      expect(signature).to eq(['uPmNH+YVl154kSH9hQdWNA=='])
    end
  end

  context '#build' do
    it 'builds form for payment' do
      builder = described_class.new(Fabricate(:payment, {
        merchant_id:    '127830694690',
        payment_amount: '100.00',
        payment_no:     '123-45',
        currency_id:    '643',
        description:    'payment test',
      }))
      builder.generate_signature('secret')
      form = builder.build
      expect(form).to be_a(Walletone::Form)
      expect(form.fields).to include(['WMI_MERCHANT_ID', 127830694690])
      expect(form.fields).to include(['WMI_CURRENCY_ID', 643])
    end
  end

  context 'validations' do
    it 'format wmi_payment_amount' do
      builder = described_class.new(Fabricate(:payment, {payment_amount: 1.2}))
      payment = builder.get_field('wmi_payment_amount').first
      expect(payment).to eq('1.20')
    end

    it 'encode wmi_description' do
      payment = Fabricate(:payment, {description: 'test'})
      builder = described_class.new(payment)
      description = builder.get_field('wmi_description').first
      expect(description).to eq('BASE64:dGVzdA==')
    end

    it 'reduces size of wmi_description to 250 symbols' do
      payment = Fabricate(:payment, {description: FFaker::Lorem.sentence(128)})
      builder = described_class.new(payment)
      description = builder.get_field('wmi_description').first
      text = Base64.decode64(description)
      expect(text.size).to be == 255
    end

    it 'formats payment expired date' do
      payment = Fabricate(:payment, {
        expired_date: Time.new(2015, 4, 1, 12, 00, 00)
      })
      builder = described_class.new(payment)
      time = builder.get_field('wmi_expired_date').first
      expect(time).to eq('2015-04-01T12:00:00+03:00')
    end

    it 'throws error with invalid wmi_success_url' do
      expect {
        described_class.new(Fabricate(:payment), wmi_success_url: 'wrong_uri')
      }.to raise_error(Walletone::WrongUrlException)
    end

    it 'throws error with invalid wmi_fail_url' do
      expect {
        described_class.new(Fabricate(:payment), wmi_fail_url: 'wrong_uri')
      }.to raise_error(Walletone::WrongUrlException)
    end
  end
end
