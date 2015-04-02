describe Walletone::Form do
  context '.initialize' do
    let(:payment) { Fabricate(:payment, merchant_id: 127830694690) }
    let(:builder) { Walletone::FormBuilder.new(payment) }

    it 'works' do
      form = described_class.new(builder)
      expect(form.fields).to include(['WMI_MERCHANT_ID', 127830694690])
    end
  end
end
