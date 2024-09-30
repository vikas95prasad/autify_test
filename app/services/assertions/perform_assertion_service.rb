require 'open-uri'
require 'nokogiri'

module Assertions
  class PerformAssertionService
    attr_reader :url, :text, :num_links, :num_images, :status, :page_content

    def initialize(url:, text:)
      @url = normalize_url(url)
      @text = text
    end

    def call
      fetch_page_content
      check_text_presence
      count_elements
      self
    end

    private

    # Ensure the URL is properly formatted
    def normalize_url(url)
      unless url =~ /\Ahttps/i
        url = "https://#{url}"
      end
      url
    end

    def fetch_page_content
      @page_content = URI.open(url).read
    rescue OpenURI::HTTPError => e
      raise "Failed to fetch URL: #{e.message}"
    end

    def check_text_presence
      @status = page_content.include?(text) ? 'pass' : 'fail'
    end

    def count_elements
      parsed_page = Nokogiri::HTML(page_content)
      @num_links = parsed_page.css('a').count
      @num_images = parsed_page.css('img').count
    end
  end
end
