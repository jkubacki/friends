# frozen_string_literal: true

class DummyResource < ApplicationResource
  # To avoid a warning
  abstract

  has_one :association1
  has_one :association2, class_name: "CustomAssociation"
  has_many :associations3
end

class Association1Resource < ApplicationResource
  abstract
  has_many :associations4
end

class Associations3Resource < ApplicationResource; end

class CustomAssociationResource < ApplicationResource
  abstract
  has_one :association5
end
