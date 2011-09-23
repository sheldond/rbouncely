module Rbouncely
  
  class Bouncely
    
    attr_reader :config
    
    DEFAULT_CONFIG = {:url => "http://api.bouncely.com/api/v1/{api_key}/{date}.{format}",
                      :api_key => "",
                      :format => "xml"}
    
    
    def initialize(new_config = nil)
      @config = DEFAULT_CONFIG
      @config.merge!(new_config)
      
      raise "You must pass an API key in your config" if @config[:api_key].blank?
      raise "You must pass a valid URL in your config" if @config[:url].blank?
    end
    
    
    def get_bounces(date)
      query = @config.url
      
      query.scan(/(\{\w+\})/).each do |match|
        query = query.replace(match, @config[match[/\w+/]])
      end
      
      p query
    end
  
  end
end
