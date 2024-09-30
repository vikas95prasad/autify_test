require 'rails_helper'

RSpec.describe Assertions::PerformAssertionService do
  describe '#call' do
    let(:url) { 'https://www.example.com' }
    let(:text) { 'Example Domain' }
    let(:service) { described_class.new(url: url, text: text) }

    before do
      # Stub the HTTP response for the example.com page
      allow(URI).to receive(:open).with(url).and_return(double(read: '<html><body><h1>Example Domain</h1><a href="#"></a></body></html>'))
    end

    it 'returns the correct number of links and images' do
      result = service.call
      expect(result.num_links).to eq(1)
      expect(result.num_images).to eq(0)
      expect(result.status).to eq('pass')
    end

    it 'handles failure when text is not found' do
      allow(URI).to receive(:open).with(url).and_return(double(read: '<html><body><h1>Other Domain</h1></body></html>'))
      result = service.call
      expect(result.status).to eq('fail')
    end

    it 'raises an error when the URL is invalid' do
      allow(URI).to receive(:open).with(url).and_raise(OpenURI::HTTPError.new("404 Not Found", nil))
      expect { service.call }.to raise_error(RuntimeError)
    end
  end
end
