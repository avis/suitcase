module Suitcase
  module Helpers
    def url(method, params, include_key=true, include_cid=true, secure=false, as_form=false)
      params["apiKey"] = Configuration.hotel_api_key if include_key
      params["cid"] = (Configuration.hotel_cid ||= 55505) if include_cid
      url = "http#{secure ? "s" : ""}://#{secure ? "book." : ""}api.ean.com/ean-services/rs/hotel/v3/#{method.to_s}#{as_form ? "" : "?"}"
      url += params.map { |key, value| "#{key}=#{value}"}.join("&")
      URI.parse(URI.escape(url))
    end


    def flight_url(method, params, include_key=true, include_cid=true, secure=false, as_form=false)
      params["apiKey"] = Configuration.hotel_api_key if include_key
      params["cid"] = (Configuration.hotel_cid ||= 55505) if include_cid
      url = "http#{secure ? "s" : ""}://#{secure ? "book." : ""}api.ean.com/ean-services/rs/air/200919/xmlinterface.jsp#{method.to_s}#{as_form ? "" : "?"}"
      url += params.map { |key, value| "#{key}=#{value}"}.join("&")
      URI.parse(URI.escape(url))  
    end

    def parse_response(uri)
      JSON.parse(Net::HTTP.get_response(uri).body)
    end
  end
end
