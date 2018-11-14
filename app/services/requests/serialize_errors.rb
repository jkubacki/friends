# frozen_string_literal: true

module Requests
  class SerializeErrors < ApplicationService
    def initialize(messages:, details:, status:)
      @messages = messages
      @details = details
      @status = status
    end

    def call
      serialize_errors_messages
      Success(errors)
    end

    private

    attr_reader :messages, :details, :status

    def add_error_object(attribute, error_pair)
      errors << {
        title: attribute.to_s,
        detail: "#{attribute.to_s.humanize} #{error_pair.first}",
        code: error_pair.last[:error].to_s,
        status: status
      }
    end

    def errors
      @errors ||= []
    end

    def fetch_error_details(message, detail)
      message.second.zip(detail.second) do |error_pair|
        add_error_object(message.first, error_pair)
      end
    end

    def serialize_errors_messages
      messages.zip(details) do |message, detail|
        fetch_error_details(message, detail)
      end
    end
  end
end
