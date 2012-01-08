require 'nokogiri'

module Suitcase
  module Helpers
      
      
    
      
    def url(method, params, include_key=true, include_cid=true, secure=false, as_form=false)
      params["apiKey"] = Configuration.hotel_api_key if include_key
      params["cid"] = (Configuration.hotel_cid ||= 55505) if include_cid
      url = "http#{secure ? "s" : ""}://#{secure ? "book." : ""}api.ean.com/ean-services/rs/hotel/v3/#{method.to_s}#{as_form ? "" : "?"}"
      url += params.map { |key, value| "#{key}=#{value}"}.join("&")
      URI.parse(URI.escape(url))
    end


    def flight_url(method, airavailabilityquery, include_key=true, include_cid=true, secure=false, as_form=false)
      #airsessionrequest["apiKey"] = Configuration.flight_api_key if include_key
      #airsessionrequest["cid"] = (Configuration.flight_cid ||= 55505) if include_cid
      
      #proc = Proc.new { |options, record| options[:builder].tag!('AirAvailabilityQuery', "") }
      requesthash = Hash.new 
      #{ attr_accesor :method}
      #requesthash.instance_variable_set(:@method, "getAirAvailability")
      #requesthash.method = 'getAirAvailability'
      
      requesthash["AirAvailabilityQuery"] = airavailabilityquery
      
      
      url = "http#{secure ? "s" : ""}://#{secure ? "book." : ""}api.ean.com/ean-services/rs/air/200919/xmlinterface.jsp#{as_form ? "" : "?"}cid=55505&resType=air&intfc=ws&apiKey=#{Configuration.flight_api_key}&#{"&xml="}"
      
      hres = requesthash.to_xml(  {:root => 'AirSessionRequest', :attributes => { :method => 'getAirAvailability'} })
      hres = hres.sub("<AirSessionRequest>", "<AirSessionRequest method='getAirAvailability'>")
      #doc = Nokogiri::XML(hres)
      #elem = doc.css('AirAvailabilityQuery').first
      #puts (elem) 
      #elem['method'] = 'getAirAvailability'
      #puts("TOXML")
      #puts(doc.to_xml)
      
      #hres.AirSessionRequest("method"=>"getAirAvailability")
      #puts("WHOLE URL")
      url += hres
      #url += airsessionrequest.to_xml(:include => { :AirAvailabilityQuery => {:include => :airsessionrequest} }, :root => 'AirSessionRequest', :attributes => { :method => 'getAirAvailability'})
      
      #url += airsessionrequest.to_xml do |xml|
      #  xml.AirAvailabilityQuery do#

    #    end
     # end
      #puts(url)
      #url += airsessionrequest.to_xml(:root => 'AirSessionRequest', :attributes => { :method => 'getAirAvailability'})
      
      #url += params.map { |key, value| "#{key}=#{value}"}.join("&")
      #xml = Builder::XmlMarkup.new( :indent => 2 )
      # xml.instruct! :xml, :encoding => "ASCII"
      # xml.product do |p|
      #   p.name "Test"
      # end
      #puts("BEFORE") 
      #AirSessionRequest = params
      #res = airsessionrequest.to_xml(:root => 'AirSessionRequest', :attributes => { :method => 'getAirAvailability'})
      #puts(a)
      
      
      #puts("AFTER")
      
      
      URI.parse(URI.escape(url))  
    end

    def parse_response_xml(uri)
      doc = Nokogiri::XML(Net::HTTP.get_response(uri).body)
      #puts(doc)
      #JSON.parse(Net::HTTP.get_response(uri).body)
    end


    def parse_response(uri)
      JSON.parse(Net::HTTP.get_response(uri).body)
    end
  end
end
