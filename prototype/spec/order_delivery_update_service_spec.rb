require 'rails_helper'

# плавают тесты
# http://i.gyazo.com/ce695f045f1eeb9941c3b64a2bc772ac.png

describe W1::OrderDeliveryUpdateService do
  let!(:order) { create :order, :delivery_redrexpress }
  let!(:vendor) { order.vendor }

  subject! { described_class.new order }

  it do
    expect(order.order_delivery.state).to eq OrderDelivery::STATE_NEW
  end

  describe do

    before :each do
      # Должны ли быть заголовки особенные?
      #   with(:body => "{\"OrderId\":#{order.id}}", :headers => W1::Requester::HEADERS).
      stub_request(:post, "https://api.w1.ru/OpenApi/order/state").
        with(:body => {"OrderId"=>order.id.to_s}).
        to_return(File.new response_file )

      #post '/OpenApi/order/state' do
      #if parsed_body['OrderId'].present?
      ##json_response 200, {orderState: "done"}
      #json_response 200, {'orderState' => 'done'}
      #else
      #status 404
      #end
    end

    describe 'delivery done' do
      let(:response_file) { './spec/fixtures/w1/update_state_done.raw' }
      pending 'Плавающий тест'
      #it 'should return order status' do
        #expect(W1.logger).to_not receive(:error)
        #subject.update_state
        #expect(order.reload.order_delivery.state).to eq(OrderDelivery::STATE_DONE)
      #end
    end

    describe 'delivery delivery' do
      let(:response_file) { './spec/fixtures/w1/update_state_delivery.raw' }
      pending 'Плавающий тест'
      #it 'should return order status' do
        #expect(W1.logger).to_not receive(:error)
        #subject.update_state
        #expect(order.reload.order_delivery.state).to eq(OrderDelivery::STATE_DELIVERY)
      #end
    end

    describe 'delivery wrong' do
      let(:response_file) { './spec/fixtures/w1/wrong.raw' }
      pending 'Плавающий тест'
      #it 'should return order status' do
        #expect(W1.logger).to receive(:error)
        #expect { subject.update_state }.to raise_exception W1::OrderDeliveryUpdateService::Error
        #expect(order.reload.order_delivery.state).to eq(OrderDelivery::STATE_NEW)
      #end
    end

  end
end
