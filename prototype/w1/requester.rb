module W1
  module Requester
    require "uri"
    require "net/http"

    def request method, uri, params='', headers={}
      uri = URI.parse(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      if uri.scheme == 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      # А куда делись uri.query?
      request = "Net::HTTP::#{method.capitalize}".constantize.new(uri.path, headers)
      request.body = params #prepare_params(params)
      #request = "Net::HTTP::#{method.capitalize}".constantize.new(uri.request_uri, headers)
      http.request(request)
    end

    def openapi_request verb, endpoint, params
      request(verb, (API_URL + endpoint), prepare_params(params), headers)
    end

    def post endpoint, params
      openapi_request(:post, endpoint, params)
    end

    def get endpoint, params
      openapi_request(:get, endpoint, params)
    end

    def prepare_params params
      Hash[params.to_hash.map {|k, v| [k.to_s.camelize, v] }].to_json
    end

    def headers
      {
        'Accept' => 'application/vnd.wallet.openapi.v1+json',
        'Content-Type' => 'application/vnd.wallet.openapi.v1+json',
        'Authorization' => "Bearer #{@vendor.w1_access_token}"
      }
    end

    def parse_response response, format=:json
      if format.to_sym == :xml
        Hash.from_xml Nokogiri::XML(response.body).to_xml
      else
        MultiJson.load response.body
      end
    rescue REXML::ParseException
    rescue MultiJson::ParseError
    end
  end
end
