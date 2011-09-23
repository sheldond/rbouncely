module Rbouncely
  
  class Bouncely
    
    attr_reader :config
    
    
    def initialize(new_config = {})
      @config = DEFAULT_CONFIG
      @config.merge!(new_config)
      
      raise "You must pass an API key in your config" if @config[:api_key].blank?
      raise "You must pass a valid URL in your config" if @config[:url].blank?
    end
    
    
    def get_bounces(date = "today")
      @config[:date] = date
      @config[:format] = DEFAULT_CONFIG[:format] # only support default format for now
      
      query = @config[:url]
      
      query.scan(/\{\w+\}/).each do |match|
        query.gsub!(match, @config[match[/\w+/].to_sym])
      end
      
      begin
        xml = Hpricot(open(query))
      rescue => e
        LOGGER.error("Rbouncely failed to GET #{query}: #{e.try(:class).try(:to_s)} #{e.try(:message)}")
      end
      
      bounces = []
        
      begin
        xml.search(:object).each do |object|
          bounces << Bounce.new(object)
        end
      rescue => e
        LOGGER.error("Rbouncely failed to parse #{@config[:format]}: #{e.try(:class).try(:to_s)} #{e.try(:message)}")
      end
      
      bounces
    end
  
  end
end
