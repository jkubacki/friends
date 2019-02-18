# frozen_string_literal: true

class ApplicationResource < JSONAPI::Resource
  abstract

  # It looks for all primary associations and nested associations of given resource and sorts them.
  # If `relation_name` as the resource class doesn't exist then it uses `class_name`.
  # @return [Array] array of strings of associations for given resource
  def self.associations
    primary_relationships
      .map { |hash| hash[:relation_name] }
      .concat(nested_relationships)
      .sort
  end

  def self.primary_relationships
    relationships_array = _relationships.values.map do |association|
      {
        relation_name: association.instance_variable_get(:@relation_name),
        class_name: association.options[:class_name],
      }
    end
    relationships_array.delete_if { |association| association[:relation_name].match?(/.+able/) }
  end

  def self.nested_relationships
    primary_relationships.flat_map do |association|
      resource_name(association).primary_relationships.map do |hash|
        "#{association[:relation_name]}.#{hash[:relation_name]}"
      end
    end
  end
  private_class_method :nested_relationships

  def self.resource_name(association_hash)
    "#{association_hash[:relation_name].classify}Resource".constantize
  rescue NameError
    "#{association_hash[:class_name].classify}Resource".constantize
  end
  private_class_method :resource_name
end
