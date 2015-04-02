describe Walletone::Payment do
  context '.initialize' do
    it 'works' do
      payment = described_class.new(merchant_id: 123)
      expect(payment.merchant_id).to eq(123)
    end
  end
end
