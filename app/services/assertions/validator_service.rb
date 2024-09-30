module Assertions
  class ValidatorService
    class ValidationError < StandardError; end

    def initialize(params)
      @url = params[:url]
      @text = params[:text]
    end

    def validate!
      validate_presence_of_params
      validate_url_format
    end

    private

    def validate_presence_of_params
      if @url.blank? || @text.blank?
        raise ValidationError, "URL and text parameters are required."
      end
    end

    def validate_url_format
      # Prepend 'http://' if the URL doesn't contain a scheme
      @url = "http://#{@url}" unless @url =~ /\Ahttp(s)?:\/\//
    
      begin
        uri = URI.parse(@url)
    
        # Check if the URL is a valid HTTP/HTTPS URI with a valid host
        if !(uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)) || uri.host.nil? || uri.host.empty? || !uri.host.include?('.')
          raise ValidationError, "Invalid URL format."
        end
      rescue URI::InvalidURIError
        raise ValidationError, "Invalid URL format."
      end
    end

  end
end
