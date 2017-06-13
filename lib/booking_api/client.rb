module BookingApi
  class Client

    def initialize
      @http_service = HttpService.new
    end

    def http_service
      @http_service
    end

    # checks for the given parameters if the hotel is available
    def hotel_availabillity(request_parameters: {})
      default_parameters = {
        room1: 'A,A',
      }
      http_service.request_post('/json/getHotelAvailabilityV2', default_parameters.merge(request_parameters))
    end

    # gets hotel photos for the given hotel ids
    def hotel_photos(hotel_ids: [], request_parameters: {})
      raise ArgumentError if hotel_ids.empty?
      default_parameters = {
        hotel_ids: hotel_ids.join(',')
      }
      response = http_service.request_post('/json/bookings.getHotelPhotos', default_parameters.merge(request_parameters))
      Images::ResponseList.new(response)
    end

    # gets hotel photos for the given hotel ids
    def hotel_description_photos(hotel_ids: [], request_parameters: {})
      raise ArgumentError if hotel_ids.empty?
      default_parameters = {
          hotel_ids: hotel_ids.join(',')
      }
      response = http_service.request_post('/json/bookings.getHotelDescriptionPhotos', default_parameters.merge(request_parameters))
      Images::ResponseList.new(response)
    end

    # gets detailed descriptions for the given hotels
    def hotel_description_translations(request_parameters: {})
      default_parameters = {}
      http_service.request_post('/json/bookings.getHotelDescriptionTranslations', default_parameters.merge(request_parameters))
    end

    # gets an overview of the data for the given hotel ids.
    def hotel_overviews(hotel_ids: [], request_parameters: {})
      default_parameters = {}
      default_parameters[:hotel_ids] = hotel_ids.join(',') if hotel_ids.any?
      http_service.request_post('/json/bookings.getHotels', default_parameters.merge(request_parameters))
    end

  end
end