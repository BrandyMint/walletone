require 'sinatra/base'

class ApiMockBase < Sinatra::Base
  helpers do
    def parsed_body
      @body ||= ::MultiJson.load(request.body.read)
    end

    def json_response(response_code, params=nil)
      content_type :json
      status response_code
      if params.is_a?(Hash)
        params.to_json
      else
        File.open(Rails.root.join('spec/fixtures', params), 'rb').read if params.present?
      end
    end

    def xml_response(response_code, params=nil)
      content_type :xml
      status response_code
      if params.is_a?(Hash)
        params.to_xml
      else
        File.open(Rails.root.join('spec/fixtures', params), 'rb').read if params.present?
      end
    end
  end

  error do
    status 404
  end
end
