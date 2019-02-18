# frozen_string_literal: true

module Helpers
  module RequestHelpers
    def json_api_params(id: nil, type:, attributes: nil, relationships: nil)
      params = {
        data: { type: type }
      }
      params[:data][:id] = id if id
      params[:data][:attributes] = attributes if attributes
      params[:data][:relationships] = relationship_strategy(relationships) if relationships
      params
    end

    def response_body
      @response_body ||= Oj.load(response.body)
    end

    def last_response_body
      @last_response_body ||= Oj.load(last_response.body)
    end

    private

    def json_api_relationships(relationships)
      relationships&.each_with_object({}) do |relation, hash|
        hash[relation_name(relation)] = {
          data: {
            type: relation_name(relation),
            id: relation_id(relation)
          }
        }
      end
    end

    def not_found_relation(relationships)
      relationships.pop
      relationships&.each_with_object({}) do |relation, hash|
        hash[relation_name(relation)] = {
          data: {
            type: relation_name(relation),
            id: relation_class_next_id(relation)
          }
        }
      end
    end

    def relationship_strategy(relationships)
      if relationships&.last == :not_found
        not_found_relation(relationships)
      else
        json_api_relationships(relationships)
      end
    end

    def relation_class_next_id(relation)
      relation = relation[:record] if relation.is_a?(Hash)
      relation.class.last.id + 1
    end

    def relation_id(relation)
      relation = relation[:record] if relation.is_a?(Hash)
      relation.try(:id).presence || relation.id
    end

    def relation_name(relation)
      return relation[:custom_name] if relation.is_a?(Hash)

      relation.class.name.underscore
    end
  end
end
