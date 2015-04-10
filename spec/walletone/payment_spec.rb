require 'walletone/form'

describe Walletone::Payment do
  let(:merchant_id) { 127830694690 }
  let(:secret_key) { '3475706857624f46344e573753316e387c396e5f4b54767b796c4c' }

  subject { described_class.new fields }

  context '.new' do
    let(:fields) { Walletone::Fields.new WMI_MERCHANT_ID: merchant_id }
    it 'works' do
      expect(subject.WMI_MERCHANT_ID).to eq(merchant_id)
    end
  end

  context '#sign' do
    let(:signature) { 'uPmNH+YVl154kSH9hQdWNA==' }
    let(:fields) { Walletone::Fields.new({
      WMI_MERCHANT_ID:    127830694690,
      WMI_PAYMENT_AMOUNT: 100.00,
      WMI_PAYMENT_NO:     '123-45',
      WMI_CURRENCY_ID:    643,
      WMI_DESCRIPTION:    'payment test',
      WMI_EXPIRED_DATE:   Time.new(2019, 12, 31, 23, 59, 59, "+00:00").utc,
      WMI_SUCCESS_URL:    'http://w1.artemeff.com/w1/success',
      WMI_FAIL_URL:       'http://w1.artemeff.com/w1/fail'
    })
    }

    before do
      subject.sign! secret_key
    end

    it { expect(subject).to be_frozen }
    it { expect(subject).to be_signed }
    it { expect(subject).to be_valid }
    it { expect(subject.WMI_SIGNATURE).to eq signature }

    it '#form' do
      expect(subject.form).to be_a Walletone::Form
    end

  end

  it 'WMI_PAYMENT_AMOUNT' do
    payment = Fabricate(:payment, {WMI_PAYMENT_AMOUNT: 1.2})
    expect(payment.WMI_PAYMENT_AMOUNT).to eq('1.20')
  end

  it 'WMI_DESCRIPTION as base64' do
    payment = Fabricate(:payment, {WMI_DESCRIPTION: 'test'})
    expect(payment.WMI_DESCRIPTION).to eq('BASE64:dGVzdA==')
  end

  it 'WMI_DESCRIPTION reduces to 250 symbols' do
    description = FFaker::Lorem.sentence(128)
    payment = Fabricate(:payment, {WMI_DESCRIPTION: description})
    text = Base64.decode64(payment.WMI_DESCRIPTION)
    expect(text.size).to eq(255)
  end

  it 'WMI_EXPIRED_DATE as ISO8601' do
    date = Time.new(2015, 4, 1, 12, 00, 00)
    payment = Fabricate(:payment, {WMI_EXPIRED_DATE: date})
    expect(payment.WMI_EXPIRED_DATE).to eq date.iso8601
  end
end
