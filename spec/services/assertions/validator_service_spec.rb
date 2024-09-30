require 'rails_helper'

RSpec.describe Assertions::ValidatorService do
  describe '#validate!' do
    context 'when url and text are present' do
      let(:params) { { url: 'http://www.example.com', text: 'Test' } }

      it 'passes validation for full URL' do
        expect { described_class.new(params).validate! }.not_to raise_error
      end

      it 'passes validation for URL without http scheme' do
        params[:url] = 'www.example.com'
        expect { described_class.new(params).validate! }.not_to raise_error
      end

      it 'passes validation for URL without www' do
        params[:url] = 'example.com'
        expect { described_class.new(params).validate! }.not_to raise_error
      end
    end

    context 'when url is missing' do
      let(:params) { { text: 'Test' } }

      it 'raises a validation error' do
        expect { described_class.new(params).validate! }.to raise_error(Assertions::ValidatorService::ValidationError, "URL and text parameters are required.")
      end
    end

    context 'when text is missing' do
      let(:params) { { url: 'http://www.example.com' } }

      it 'raises a validation error' do
        expect { described_class.new(params).validate! }.to raise_error(Assertions::ValidatorService::ValidationError, "URL and text parameters are required.")
      end
    end

    context 'when the URL is invalid' do
      let(:params) { { url: 'invalid_url', text: 'Test' } }

      it 'raises a validation error' do
        expect { described_class.new(params).validate! }.to raise_error(Assertions::ValidatorService::ValidationError, "Invalid URL format.")
      end
    end
  end
end
