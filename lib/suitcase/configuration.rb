module Suitcase
  class Configuration
    def self.cache=(store)
      @@cache = Suitcase::Cache.new(store)
    end

    def self.cache
      return @@cache if cache?
      nil
    end

    def self.cache?
      defined? @@cache
    end

    def self.hotel_api_key=(key)
      @@hotel_api_key = key
    end

    def self.hotel_api_key
      @@hotel_api_key
    end

    def self.hotel_cid=(cid)
      @@hotel_cid = cid
    end

    def self.hotel_cid
      @@hotel_cid if defined? @@hotel_cid
    end
    
    # @avi Flight
  
    def self.flight_api_key=(key)
      @@flight_api_key = key
    end

    def self.flight_api_key
      @@flight_api_key
    end

    def self.flight_cid=(cid)
      @@flight_cid = cid
    end

    def self.flight_cid
      @@flight_cid if defined? @@flight_cid
    end
    
    
    
  end
end
