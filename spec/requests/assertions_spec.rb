require 'rails_helper'

RSpec.describe "Assertions API", type: :request do
  describe "POST /api/v1/assertions" do
    let(:url) { "https://example.com" }
    let(:text) { "sample text" }

    context "when the page contains the text" do
      before do
        allow(URI).to receive(:open).and_return("<html><body>sample text</body></html>")
      end

      it "returns a PASS status" do
        post "/api/v1/assertions", params: { url: url, text: text }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['status']).to eq('PASS')
      end
    end

    context "when the page does not contain the text" do
      before do
        allow(URI).to receive(:open).and_return("<html><body>no matching text here</body></html>")
      end

      it "returns a FAIL status" do
        post "/api/v1/assertions", params: { url: url, text: text }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['status']).to eq('FAIL')
      end
    end

    context "when the URL is invalid" do
      it "returns a bad request error" do
        post "/api/v1/assertions", params: { url: "invalid_url", text: text }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to be_present
      end
    end
  end
end
