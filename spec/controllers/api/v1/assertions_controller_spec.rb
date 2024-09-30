# spec/requests/api/v1/assertions_spec.rb
require 'rails_helper'
require 'webmock/rspec'

RSpec.describe Api::V1::AssertionsController, type: :request do
  let(:valid_url) { 'https://www.example.com' }

  describe 'GET /api/v1/assertions' do
    before do
      create(:assertion, url: valid_url, text: 'ai-powered', status: 'pass')
      create(:assertion, url: valid_url, text: 'AI-powered', status: 'fail')
    end

    it 'returns a list of assertions with metadata' do
      get '/api/v1/assertions'

      expect(response).to have_http_status(200)
      expect(json.length).to eq(2)

      # Check the structure and values of the first returned assertion
      expect(json[0]['url']).to eq(valid_url)
      expect(json[0]['text']).to eq('ai-powered')
      expect(json[0]['status']).to eq('PASS')
      expect(json[0]['snapshotUrl']).to eq("http://www.example.com/snapshots/#{Assertion.first.id}/index.html")

      # Check the structure and values of the second returned assertion
      expect(json[1]['url']).to eq(valid_url)
      expect(json[1]['text']).to eq('AI-powered')
      expect(json[1]['status']).to eq('FAIL')
      expect(json[1]['snapshotUrl']).to eq("http://www.example.com/snapshots/#{Assertion.second.id}/index.html")
    end
  end

  describe 'POST /api/v1/assertions' do
    context 'when the request is valid' do
      let(:valid_attributes) do
        {
          url: valid_url,
          text: 'ai-powered'
        }
      end

      before do
        stub_request(:get, valid_url)
          .to_return(status: 200, body: "<html><body><p>ai-powered</p></body></html>", headers: {})
      end

      it 'creates a new assertion and returns status PASS' do
        post '/api/v1/assertions', params: valid_attributes

        expect(response).to have_http_status(200)
        expect(json['status']).to eq("PASS")

        assertion = Assertion.last
        expect(assertion.url).to eq(valid_attributes[:url])
        expect(assertion.text).to eq(valid_attributes[:text])
        expect(assertion.status.upcase).to eq("PASS")
      end
    end

    context 'when the request is invalid (text not found)' do
      let(:invalid_attributes) do
        {
          url: valid_url,
          text: 'non-existent-text'
        }
      end

      before do
        stub_request(:get, valid_url)
          .to_return(status: 200, body: "<html><body><p>not-relevant-content</p></body></html>", headers: {})
      end

      it 'creates a new assertion and returns status FAIL' do
        post '/api/v1/assertions', params: invalid_attributes

        expect(response).to have_http_status(200)
        expect(json['status']).to eq('FAIL')

        assertion = Assertion.last
        expect(assertion.url).to eq(invalid_attributes[:url])
        expect(assertion.text).to eq(invalid_attributes[:text])
        expect(assertion.status.upcase).to eq('FAIL')
      end
    end
  end
end
