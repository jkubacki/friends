# frozen_string_literal: true

require "dry/monads/result"
require "dry/monads/do/all"

class ApplicationService
  extend StaticFacade
  include Dry::Monads::Result::Mixin
  include Dry::Monads::Do::All
end
