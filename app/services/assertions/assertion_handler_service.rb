module Assertions
  class AssertionHandlerService
    attr_reader :url, :text, :assertion

    def initialize(url:, text:)
      @url = url
      @text = text
    end

    def call
      perform_assertion
      create_assertion_record
      save_snapshot
      self
    end

    private

    def perform_assertion
      @assertion_service = Assertions::PerformAssertionService.new(url: url, text: text).call
    end

    def create_assertion_record
      @assertion = Assertion.create!(
        url: assertion_service.url,
        text: text,
        status: assertion_service.status,
        num_links: assertion_service.num_links,
        num_images: assertion_service.num_images
      )
    end

    def save_snapshot
      Assertions::SnapshotService.new(assertion, assertion_service.page_content).call
    end

    def assertion_service
      @assertion_service
    end
  end
end
