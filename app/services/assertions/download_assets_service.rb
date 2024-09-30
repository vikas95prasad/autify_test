require 'open-uri'
require 'nokogiri'

module Assertions
  class DownloadAssetsService
    ASSET_TYPES = ['img', 'link[rel="stylesheet"]'].freeze

    attr_reader :html_content, :snapshot_dir, :base_url

    def initialize(html_content, snapshot_dir, base_url)
      @html_content = Nokogiri::HTML(html_content)
      @snapshot_dir = snapshot_dir
      @base_url = base_url
    end

    def call
      download_assets
      save_updated_html
    end

    private

    # def download_assets
    #   html_content.css(*ASSET_TYPES).each do |element|
    #     asset_url = element['src'] || element['href']
    #     next unless asset_url

    #     asset_url = asset_url.start_with?('/') ? URI.join(base_url, asset_url).to_s : asset_url
    #     filename = File.basename(asset_url)
    #     asset_path = "#{snapshot_dir}/#{filename}"

    #     begin
    #       binding.pry
    #       File.write(asset_path, URI.open(asset_url).read)

    #       # Update asset URLs to local paths
    #       if element.name == 'img'
    #         element['src'] = filename
    #       elsif element.name == 'link'
    #         element['href'] = filename
    #       end
    #     rescue OpenURI::HTTPError => e
    #       Rails.logger.error "Failed to download asset #{asset_url}: #{e.message}"
    #     end
    #   end
    # end

    def download_assets
      html_content.css(*ASSET_TYPES).each do |element|
        asset_url = element['src'] || element['href']
        next unless asset_url
    
        asset_url = asset_url.start_with?('/') ? URI.join(base_url, asset_url).to_s : asset_url
        filename = File.basename(asset_url)
        asset_path = "#{snapshot_dir}/#{filename}"
    
        begin
          # Open and write the file in binary mode
          File.open(asset_path, 'wb') do |file|
            file.write(URI.open(asset_url).read)
          end
    
          # Update asset URLs to local paths
          if element.name == 'img'
            element['src'] = filename
          elsif element.name == 'link'
            element['href'] = filename
          end
        rescue OpenURI::HTTPError => e
          Rails.logger.error "Failed to download asset #{asset_url}: #{e.message}"
        end
      end
    end

    def save_updated_html
      File.write("#{snapshot_dir}/index.html", html_content.to_html)
    end
  end
end
