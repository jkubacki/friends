# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scheduling::WeekendDays do
  include ActiveSupport::Testing::TimeHelpers

  subject { described_class.call }

  before { travel_to Time.zone.local(2019, 2, 18, 0, 0) }
  after { travel_back }

  let(:saturday) { '2019-02-23'.to_date }
  let(:sunday) { '2019-02-24'.to_date }

  it 'returns array with this saturday and sunday' do
    expect(subject).to eq [saturday, sunday]
  end
end
