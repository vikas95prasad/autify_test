require 'rails_helper'

RSpec.describe Assertion, type: :model do
  # Using FactoryBot to create test data
  subject { build(:assertion) }

  # Test validations
  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a URL" do
      subject.url = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:url]).to include("can't be blank")
    end

    it "is not valid without text" do
      subject.text = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:text]).to include("can't be blank")
    end

    it "is not valid without a status" do
      subject.status = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:status]).to include("can't be blank")
    end

    it "is not valid with an invalid status" do
      subject.status = "INVALID"
      expect(subject).to_not be_valid
      expect(subject.errors[:status]).to include("is not included in the list")
    end

    it "is valid with 'PASS' or 'FAIL' status" do
      subject.status = "PASS"
      expect(subject).to be_valid

      subject.status = "FAIL"
      expect(subject).to be_valid
    end

    it "is not valid without num_links" do
      subject.num_links = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:num_links]).to include("can't be blank")
    end

    it "is not valid without num_images" do
      subject.num_images = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:num_images]).to include("can't be blank")
    end
  end

  # Test custom methods (if any)
  describe "custom methods" do
    # Example: if the model has a method that processes assertions in some way.
    # Replace this with the actual methods if they exist.
    it "does something custom" do
      # Example of how to test custom methods
      # expect(subject.custom_method).to eq(some_value)
    end
  end
end
