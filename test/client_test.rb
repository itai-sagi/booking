require 'test_helper'

describe BookingApi::Client do
  let(:client) { BookingApi::Client.new }
  describe "#http_service" do
    it "returns a http service" do
      assert_equal BookingApi::HttpService, BookingApi::Client.new.http_service.class
    end
  end

  describe "#hotel_description_photos" do
    let(:sample_response) do
      [
        {
          url_square60: "http://aff.bstatic.com/images/hotel/square60/333/33377034.jpg",
          photo_id: "33377034",
          descriptiontype_id: "10",
          url_original: "http://aff.bstatic.com/images/hotel/max500/333/33377034.jpg",
          hotel_id: "17675",
          url_max300: "http://aff.bstatic.com/images/hotel/max300/333/33377034.jpg"
        },
        {
          url_max300: "http://aff.bstatic.com/images/hotel/max300/948/9485096.jpg",
          url_original: "http://aff.bstatic.com/images/hotel/max500/948/9485096.jpg",
          hotel_id: "17675",
          descriptiontype_id: "1",
          photo_id: "9485096",
          url_square60: "http://aff.bstatic.com/images/hotel/square60/948/9485096.jpg"
        }
      ]
    end

    before(:each) do
      stub_request(:any, /.*booking.com.*/).
      to_return(:status => 200, :body => sample_response, :headers => {})
    end

    it "has a method" do
      assert_equal true, client.respond_to?(:hotel_description_photos)
    end

    it "requires an array of hotel ids" do
      assert_raises ArgumentError do
        client.hotel_description_photos
      end
      client.hotel_description_photos(hotel_ids: [1,2])
    end

    it "returns a response list" do
      assert_equal BookingApi::Images::ResponseList, client.hotel_description_photos(hotel_ids: [1,2]).class
    end

    it "returns an array of entries" do
      entries = client.hotel_description_photos(hotel_ids: [1,2]).entries
      assert_equal BookingApi::Images::Image, entries.first.class
    end

    it "raises an error if the body is a string or nil" do
      stub_request(:any, /.*booking.com.*/).
      to_return(:status => 200, :body => "", :headers => {})
      assert_raises JSON::ParserError do
        client.hotel_description_photos(hotel_ids: [1,2]).entries
      end
      stub_request(:any, /.*booking.com.*/).
      to_return(:status => 200, :body => nil, :headers => {})
      assert_raises JSON::ParserError do
        client.hotel_description_photos(hotel_ids: [1,2]).entries
      end
    end
  end


  describe "#get_hotel_description_translations" do
    let(:sample_response) do
      [
        {
          "description": "Das Asterisk Hotel bietet 3-Sterne-Unterkünfte in 2 renovierten Gebäuden aus dem 19. Jahrhundert im Zentrum von Amsterdam. Die Unterkunft ist 10 Minuten vom Rijksmuseum entfernt und verfügt über kostenloses WLAN in allen Bereichen.",
          "descriptiontype_id": 6,
          "hotel_id": "10003",
          "languagecode": "de"
        },
        {
          "description": "Asterisk Hotel offers 3-star accommodation in 2 restored 19th century buildings in the centre of Amsterdam. It is situated 10 minutes from the Rijksmuseum and offers free WiFi in the entire property.",
          "hotel_id": "10003",
          "descriptiontype_id": 6,
          "languagecode": "en"
        },
      ]
    end

    before(:each) do
      stub_request(:any, /.*booking.com.*/).
      to_return(:status => 200, :body => sample_response, :headers => {})
    end

    it "returns a Faraday::Response object containing the response in the `body` method" do
      response = client.get_hotel_description_translations
      assert_equal Faraday::Response, response.class
      assert_equal Array, response.body.class
      assert_equal sample_response.length, response.body.length
    end
  end
end