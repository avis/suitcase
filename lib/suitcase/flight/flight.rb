module Suitcase
  #class EANException < Exception
  #  def initialize(message)
  #    super(message)
  #  end
  #end
  
  
  class Flight
    extend Suitcase::Helpers
    
    def initialize(info)
      info.each do |k, v|
        send (k.to_s + "=").to_sym, v
      end
    end
    
    
     def self.find(info)
        if info[:id]
          find_by_id(info[:id])
        else
          find_by_info(info)
        end
      end

      def self.find_by_id(id)
        params = { hotelId: id }
        if Configuration.cache? and Configuration.cache.cached?(:info, params)
          raw = Configuration.cache.get_query(:info, params)
        else
          url = flight_url(:info, params)
          raw = parse_response(url)
          Configuration.cache.save_query(:info, params, raw) if Configuration.cache?
        end
        flight_data = parse_information(raw)
        Flight.new(flight_data)
      end


#flights = Suitcase::Flight.find(:originCityCode => 'SFO', :destinationCityCode => TLV, :departureDateTime => '04/19/2012 11:00 AM', :returnDateTime => '06/19/2012 11:00 AM', Passengers => '1', :results => 10)

      def self.find_by_info(info)
        params = info
        params["numResultsRequested"] = params[:results] ? params[:results] : 10
        params.delete(:results)
        params["originCityCode"] = params[:originCityCode].upcase
        params.delete(:originCityCode)
        params["destinationCityCode"] = params[:destinationCityCode].upcase
        params.delete(:destinationCityCode)
        params["departureDateTime"] = params[:departureDateTime]
        params["returnDateTime"] = params[:returnDateTime]
        params["tripType"] = "R" # roundtrip? 
        params["xmlResultFormat"] = "2"
        params["Passengers"] = Hash.new #{["adultPassengers"]}
        params["Passengers"]["adultPassengers"] = params[:Passengers]
        params["fareClass"] = "B"
        
        #puts(flight_url(:list, params))
        parsed = parse_response_xml(flight_url(:list, params))
        
        #flights = []
        #parsed = parse_response(url(:list, params))
        #handle_errors(parsed)
        #split(parsed).each do |hotel_data|
        #  hotels.push Hotel.new(parse_information(hotel_data))
        #end
        #flights
        
        
      end
    
    
    def self.parse_information(parsed)
      handle_errors(parsed)
      summary = parsed["hotelId"] ? parsed : parsed["HotelInformationResponse"]["HotelSummary"]
      parsed_info = { id: summary["hotelId"], name: summary["name"], address: summary["address1"], city: summary["city"], postal_code: summary["postalCode"], country_code: summary["countryCode"], rating: summary["hotelRating"], high_rate: summary["highRate"], low_rate: summary["lowRate"], latitude: summary["latitude"].to_f, longitude: summary["longitude"].to_f }
      parsed_info[:images] = images(parsed) if images(parsed)
      parsed_info
    end
    
    
  end
end