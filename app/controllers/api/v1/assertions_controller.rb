module Api
  module V1
    class AssertionsController < ApplicationController
      def index
        assertions = Assertion.all
        render json: assertions.map { |assertion|
          assertion.as_json.merge(
            snapshotUrl: request.base_url + "/snapshots/#{assertion.id}/index.html"
          )
        }, status: :ok
      end

      def create
        # Validate the input params
        validate_params

        # Proceed with the assertion service after validation
        assertion_service = Assertions::AssertionHandlerService.new(
          url: assertion_params[:url],
          text: assertion_params[:text]
        ).call

        render json: {
          status: assertion_service.assertion.status.upcase,
          snapshotUrl: request.base_url + "/snapshots/#{assertion_service.assertion.id}/index.html"
        }, status: :ok
      rescue Assertions::ValidatorService::ValidationError => e
        render json: { error: e.message }, status: :unprocessable_entity
      rescue StandardError => e
        render json: { error: e.message }, status: :bad_request
      end

      private

      def assertion_params
        params.permit(:url, :text)
      end

      def validate_params
        Assertions::ValidatorService.new(assertion_params).validate!
      end
    end
  end
end
