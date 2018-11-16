# frozen_string_literal: true

module API
  module V1
    module Users
      module Confirmations
        class Base < Base
          resource :confirmations do
            mount Create
          end
        end
      end
    end
  end
end
