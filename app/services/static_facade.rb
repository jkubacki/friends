# frozen_string_literal: true

# Static facade for #call method

module StaticFacade
  def call(*args)
    new(*args).call
  end
end
