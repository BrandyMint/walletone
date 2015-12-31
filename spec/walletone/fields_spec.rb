require 'walletone/fields'

describe Walletone::Fields do
  describe 'Именованные поля' do
    subject { Walletone::Payment.new }
    let(:merchant_id) { 'some_id' }

    it 'nill by default' do
      expect(subject.WMI_MERCHANT_ID).to eq nil
    end
    it { expect(subject.WMI_MERCHANT_ID = merchant_id).to eq merchant_id }

    context 'установили заранее' do
      let(:merchant_id) { 'some_id2' }
      before { subject.WMI_MERCHANT_ID = merchant_id }
      it { expect(subject.WMI_MERCHANT_ID).to eq merchant_id }
    end
  end

  describe '#initialize' do
    let(:fail_url) { 'someurl' }
    let(:attrs) { { 'WMI_FAIL_URL' => fail_url } }
    subject { Walletone::Payment.new attrs }

    it { expect(subject.WMI_FAIL_URL).to eq fail_url }
    it { expect(subject['WMI_FAIL_URL']).to eq fail_url }
    it { expect(subject[:WMI_FAIL_URL]).to eq fail_url }
  end

  describe '#fetch as keys and keys maybe as symbols or as strings' do
    let(:fail_url) { 'someurl' }
    let(:attrs) { { WMI_FAIL_URL: fail_url } }
    subject { described_class.new attrs }

    it { expect(subject[:WMI_FAIL_URL]).to eq fail_url }
    it { expect(subject['WMI_FAIL_URL']).to eq fail_url }
  end

  describe '#as_list' do
    let(:fail_url) { 'someurl' }
    let(:pt_enabled) { %w(WebMoneyRUB WebMoneyUSD) }
    let(:attrs) { { WMI_FAIL_URL: fail_url, WMI_PTENABLED: pt_enabled } }

    subject { described_class.new(attrs).as_list }

    it 'получаем список полей в строчном варианте' do
      expect(subject).to eq [%w(WMI_FAIL_URL someurl), %w(WMI_PTENABLED WebMoneyRUB), %w(WMI_PTENABLED WebMoneyUSD)]
    end
  end
end
