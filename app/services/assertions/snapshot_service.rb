require 'fileutils'

module Assertions
  class SnapshotService
    SNAPSHOTS_PATH = 'public/snapshots'.freeze

    attr_reader :assertion, :html_content

    def initialize(assertion, html_content)
      @assertion = assertion
      @html_content = html_content
    end

    def call
      save_snapshot
      self
    end

    private

    def save_snapshot
      snapshot_dir = "#{SNAPSHOTS_PATH}/#{assertion.id}"
      FileUtils.mkdir_p(snapshot_dir)

      # Save the HTML content to a file
      File.write("#{snapshot_dir}/index.html", html_content)

      # Download assets
      Assertions::DownloadAssetsService.new(html_content, snapshot_dir, assertion.url).call
    end
  end
end
