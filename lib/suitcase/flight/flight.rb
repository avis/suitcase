module Suitcase
  class EANException < Exception
    def initialize(message)
      super(message)
    end
  end
  
  
  class Hotel
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
        url = url(:info, params)
        raw = parse_response(url)
        Configuration.cache.save_query(:info, params, raw) if Configuration.cache?
      end
      hotel_data = parse_information(raw)
      Hotel.new(hotel_data)
    end
    
    
    
    
    
  end