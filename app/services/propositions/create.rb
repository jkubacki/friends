# frozen_string_literal: true

module Propositions
  class Create < ApplicationService
    def initialize(group:, date:)
      @group = group
      @date = date
    end

    def call
      # TODO
      Success(nil)
    end

    private

    attr_reader :group, :date
  end
end
