require 'open-uri'
require 'nokogiri'
require 'fileutils'

module Api
  module V1
    class AssertionsController < ApplicationController
      SNAPSHOTS_PATH = 'public/snapshots'.freeze

      def create
        url = params[:url]
        text_to_search = params[:text]

        begin
          # Fetch and parse the webpage content
          page_content = URI.open(url).read
          parsed_page = Nokogiri::HTML(page_content)

          # Count the number of links and images on the page
          num_links = parsed_page.css('a').count
          num_images = parsed_page.css('img').count

          # Check if the page content contains the text
          status = page_content.include?(text_to_search) ? 'PASS' : 'FAIL'

          # Create a new Assertion record in the database
          assertion = Assertion.create!(
            url: url,
            text: text_to_search,
            status: status,
            num_links: num_links,
            num_images: num_images
          )

          # Download and save the snapshot of the webpage
          snapshot_path = save_snapshot(url, assertion.id)

          # Respond with status and metadata
          render json: { 
            status: status, 
            snapshotUrl: request.base_url + "/snapshots/#{assertion.id}",
          }, status: :ok
        rescue OpenURI::HTTPError => e
          render json: { error: "Failed to fetch URL: #{e.message}" }, status: :bad_request
        rescue StandardError => e
          render json: { error: e.message }, status: :internal_server_error
        end
      end

      # New action to retrieve all assertions
      def index
        assertions = Assertion.all
        render json: assertions.map { |assertion|
          assertion.as_json.merge(
            snapshotUrl: request.base_url + "/snapshots/#{assertion.id}"
          )
        }, status: :ok
      end

      private

      # Save the HTML and assets of the webpage as a snapshot
      def save_snapshot(url, assertion_id)
        # Define a directory for this specific snapshot
        snapshot_dir = "#{SNAPSHOTS_PATH}/#{assertion_id}"
        FileUtils.mkdir_p(snapshot_dir)

        # Fetch the webpage
        page_content = URI.open(url).read
        parsed_page = Nokogiri::HTML(page_content)

        # Save the HTML to a file
        File.write("#{snapshot_dir}/index.html", parsed_page.to_html)

        # Download assets (images and CSS files)
        download_assets(parsed_page, snapshot_dir, url)

        # Return the snapshot path
        snapshot_dir
      end

      # Download and save images, CSS files, etc.
      def download_assets(parsed_page, snapshot_dir, base_url)
        parsed_page.css('img, link[rel="stylesheet"]').each do |element|
          asset_url = element['src'] || element['href']
          next if asset_url.nil?

          # Handle relative URLs
          if asset_url.start_with?('/')
            asset_url = URI.join(base_url, asset_url).to_s
          end

          # Determine the local path for the asset
          filename = File.basename(asset_url)
          asset_path = "#{snapshot_dir}/#{filename}"

          begin
            # Download the asset
            File.write(asset_path, URI.open(asset_url).read)

            # Update the HTML references to the local file
            if element.name == 'img'
              element['src'] = filename
            elsif element.name == 'link'
              element['href'] = filename
            end
          rescue OpenURI::HTTPError => e
            # Skip assets that can't be downloaded
            Rails.logger.error "Failed to download asset #{asset_url}: #{e.message}"
          end
        end
      end
    end
  end
end
