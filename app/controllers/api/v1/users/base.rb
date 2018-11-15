# frozen_string_literal: true

module API
  module V1
    module Users
      class Base < Base
        resource :users do
          before { authenticate_user! }

          namespace :me do
            mount Users::Me::Show
          end
        end

        resource :users do
          mount Create
        end
      end
    end
  end
end
