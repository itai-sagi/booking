module BookingApi
  class HttpService

    attr_accessor :username, :password

    def initialize(username: nil, password: nil)
      @username = username || BookingApi.username
      @password = password || BookingApi.password
    end

    def connection
      @connection ||= begin
        Faraday.new(:url => 'https://distribution-xml.booking.com') do |faraday|
          faraday.basic_auth username, password
          faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
          faraday.response :json, :content_type => /\bjson$/
        end
      end
    end

    def request_post(url, data)
      connection.post do |req|
        req.url url
        req.headers['Content-Type'] = 'application/json'
        req.body = data.to_json
      end
    end

  end
end
