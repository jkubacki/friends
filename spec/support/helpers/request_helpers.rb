# frozen_string_literal: true

module Helpers
  module RequestHelpers
    def response_body
      @response_body ||= Oj.load(response.body)
    end
  end
end
