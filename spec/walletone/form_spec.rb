describe Walletone::Form do
  let(:sample_form) do
    [
      [:wmi_merchant_id,    FFaker.numerify('############').to_i],
      [:wmi_payment_amount, FFaker.numerify('##.##').to_f],
      [:wmi_currency_id,    [643, 840, 978].sample],
      [:wmi_description,    FFaker::HipsterIpsum.words(3).join(' ')],
      [:wmi_success_url,    FFaker::Internet.uri('http')],
      [:wmi_fail_url,       FFaker::Internet.uri('http')]
    ]
  end

  context '.initialize' do
    it 'add fields' do
      builder = described_class.new(sample_form)
      expect(builder.fields.size).to be > 0
    end

    it 'add extra fields' do
      builder = described_class.new([[:foo, 'bar']])
      expect(builder.get_field('foo')).to eq(['bar'])
    end

    it 'accept hash' do
      builder = described_class.new({foo: 'bar'})
      expect(builder.get_field('foo')).to eq(['bar'])
    end
  end

  context '#add_field' do
    it 'accept fields with same name' do
      builder = described_class.new
      builder.add_field(:same, 'foo')
      builder.add_field(:same, 'bar')
      expect(builder.get_field(:same)).to eq(['foo', 'bar'])
    end
  end

  context '#generate_signature' do
    it 'with empty form' do
      builder = described_class.new
      builder.generate_signature('sekR3t')
      signature = builder.get_field('wmi_signature')
      expect(signature).to eq(['Ww+zu46Kt4LD9MwZD50Tlw=='])
    end

    it 'ignores custom wmi_signature field' do
      builder = described_class.new([[:wmi_signature, 'wrong_sign']])
      builder.generate_signature('sekR3t')
      signature = builder.get_field('wmi_signature')
      expect(signature).to eq(['Ww+zu46Kt4LD9MwZD50Tlw=='])
    end

    it 'with valid form' do
      secret  = '3475706857624f46344e573753316e387c396e5f4b54767b796c4c'
      builder = described_class.new({
        wmi_merchant_id:    '127830694690',
        wmi_payment_amount: '100.00',
        wmi_payment_no:     '123-45',
        wmi_currency_id:    '643',
        wmi_description:    'payment test',
        wmi_expired_date:   '2019-12-31T23:59:59',
        wmi_success_url:    'http://w1.artemeff.com/w1/success',
        wmi_fail_url:       'http://w1.artemeff.com/w1/fail'
      })
      builder.generate_signature(secret)
      signature = builder.get_field('wmi_signature')
      expect(signature).to eq(['NqWColL0fo4BUqyy0jltPQ=='])
    end
  end

  context '#build' do
    it 'builds fields for form' do
      builder = described_class.new({
        wmi_merchant_id:    '127830694690',
        wmi_payment_amount: '100.00',
        wmi_payment_no:     '123-45',
        wmi_currency_id:    '643',
        wmi_description:    'payment test',
      })
      builder.generate_signature('secret')
      form = builder.build
      expect(form).to include(['WMI_MERCHANT_ID', '127830694690'])
      expect(form).to include(['WMI_CURRENCY_ID', '643'])
    end
  end

  context 'validations' do
    it 'format wmi_payment_amount' do
      builder = described_class.new([[:wmi_payment_amount, 1.2]])
      payment = builder.get_field('wmi_payment_amount').first
      expect(payment).to eq('1.20')
    end

    it 'encode wmi_description' do
      builder = described_class.new([[:wmi_description, 'test']])
      description = builder.get_field('wmi_description').first
      expect(description).to eq('BASE64:dGVzdA==')
    end

    it 'reduces size of wmi_description to 250 symbols' do
      builder = described_class.new([[:wmi_description, FFaker::Lorem.sentence(128)]])
      description = builder.get_field('wmi_description').first
      text = Base64.decode64(description)
      expect(text.size).to be == 255
    end

    it 'throws error with invalid wmi_success_url' do
      expect {
        described_class.new([[:wmi_success_url, 'wrong_uri']])
      }.to raise_error(Walletone::WrongUrlException)
    end

    it 'throws error with invalid wmi_fail_url' do
      expect {
        described_class.new([[:wmi_fail_url, 'wrong_uri']])
      }.to raise_error(Walletone::WrongUrlException)
    end
  end
end
