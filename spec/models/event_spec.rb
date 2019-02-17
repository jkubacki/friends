# frozen_string_literal: true

require "rails_helper"

RSpec.describe Event, type: :model do
  it { is_expected.to validate_presence_of :group }
  it { is_expected.to validate_presence_of :proposition }
  it { is_expected.to validate_presence_of :date }
end
