require 'rails_helper'

RSpec.describe Assertions::DownloadAssetsService do
  let(:html_content) { '<html><body><img src="http://www.example.com/image.png"><link rel="stylesheet" href="http://www.example.com/styles.css"></body></html>' }
  let(:snapshot_dir) { Rails.root.join('public', 'snapshots', '1') }
  let(:base_url) { 'http://www.example.com' }
  let(:service) { described_class.new(html_content, snapshot_dir, base_url) } # Use raw HTML string

  before do
    FileUtils.mkdir_p(snapshot_dir)
    allow(URI).to receive(:open).and_return(double(read: 'dummy content'))
  end

  it 'downloads images and CSS files' do
    service.call
    expect(File.exist?(snapshot_dir.join('image.png'))).to be true
    expect(File.exist?(snapshot_dir.join('styles.css'))).to be true
  end

  it 'handles invalid asset URLs gracefully' do
    allow(URI).to receive(:open).with(anything).and_raise(OpenURI::HTTPError.new("404 Not Found", nil))
    expect { service.call }.not_to raise_error
  end
end
