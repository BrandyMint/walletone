require_relative 'api_mock_base'
require 'sinatra/base'

class W1ApiMock < ApiMockBase
  before do
    halt 401 unless request.env['HTTP_AUTHORIZATION'] == 'Bearer access_token'
    halt 406 unless request.env['HTTP_ACCEPT'] == 'application/vnd.wallet.openapi.v1+json'
    halt 415 unless request.env['CONTENT_TYPE'] == 'application/vnd.wallet.openapi.v1+json'
  end

  post '/OpenApi/registration/users' do
    case true
    when parsed_body['Login'] == '+77777777777'
      json_response 400, 'w1/duplicate_merchant.json'
    when parsed_body['AccountTypeId'] == 'Personal' && parsed_body['PromoCodeId'] == Rails.application.secrets.w1['personal_code'] && parsed_body['Login'].present?
      json_response 201, 'w1/personal_merchant.json'
    when parsed_body['AccountTypeId'] == 'Business' && parsed_body['PromoCodeId'] == Rails.application.secrets.w1['business_code'] && parsed_body['Login'].present?
      json_response 201, 'w1/business_merchant.json'
    else
      status 404
    end
  end
end
