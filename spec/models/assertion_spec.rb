# spec/models/assertion_spec.rb
require 'rails_helper'

RSpec.describe Assertion, type: :model do
  subject(:assertion) { build(:assertion) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(assertion).to be_valid
    end

    it 'is invalid without a url' do
      assertion.url = nil
      expect(assertion).not_to be_valid
      expect(assertion.errors[:url]).to include("can't be blank")
    end

    it 'is invalid without a text' do
      assertion.text = nil
      expect(assertion).not_to be_valid
      expect(assertion.errors[:text]).to include("can't be blank")
    end

    it 'is invalid without a status' do
      assertion.status = nil
      expect(assertion).not_to be_valid
      expect(assertion.errors[:status]).to include("can't be blank")
    end

    it 'is invalid with an incorrect URL format' do
      assertion.url = 'invalid-url'
      expect(assertion).not_to be_valid
      expect(assertion.errors[:url]).to include('must be a valid URL')
    end

    it 'is valid with a correct URL format' do
      assertion.url = 'https://example.com'
      expect(assertion).to be_valid
    end

    it 'is valid with status PASS or FAIL' do
      assertion.status = 'pass'
      expect(assertion).to be_valid

      assertion.status = 'fail'
      expect(assertion).to be_valid
    end
  end

  describe 'metadata calculations' do
    it 'returns the correct number of links' do
      assertion.num_links = 42
      expect(assertion.num_links).to eq(42)
    end

    it 'returns the correct number of images' do
      assertion.num_images = 10
      expect(assertion.num_images).to eq(10)
    end
  end
end
