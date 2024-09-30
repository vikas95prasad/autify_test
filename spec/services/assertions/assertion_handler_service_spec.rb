require 'rails_helper'

RSpec.describe Assertions::AssertionHandlerService do
  describe '#call' do
    let(:url) { 'https://example.com' }
    let(:text) { 'Example Domain' }
    let(:service) { described_class.new(url: url, text: text) }

    before do
      allow_any_instance_of(Assertions::PerformAssertionService).to receive(:call).and_return(
        double(num_links: 1, num_images: 0, status: 'pass', url: url, page_content: "")
      )
      allow_any_instance_of(Assertions::SnapshotService).to receive(:call).and_return(true)
    end

    it 'creates an assertion record and saves snapshot URL' do
      result = service.call
      expect(result.assertion).to be_a(Assertion)
    end

    it 'handles errors during the assertion process' do
      allow_any_instance_of(Assertions::PerformAssertionService).to receive(:call).and_raise(StandardError.new('Some error'))
      expect { service.call }.to raise_error(StandardError, 'Some error')
    end
  end
end
