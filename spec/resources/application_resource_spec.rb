# frozen_string_literal: true

require "rails_helper"

describe ApplicationResource do
  describe "abstract" do
    subject { described_class.abstract }
    it { is_expected.to be true }
  end

  describe ".associations" do
    let(:result) do
      ["association1", "association1.associations4", "association2",
       "association2.association5", "associations3"]
    end
    subject { DummyResource.associations }

    it "returns a sorted array of resource associations and its nested associations" do
      is_expected.to eq(result)
    end
  end
end
