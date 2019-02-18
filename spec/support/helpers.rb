# frozen_string_literal: true

require "support/helpers/request_helpers"
require "support/helpers/time_range_helpers"

RSpec.configure do |config|
  config.include Helpers::RequestHelpers
  config.include Helpers::TimeRangeHelpers
end
