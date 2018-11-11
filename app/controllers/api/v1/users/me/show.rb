# frozen_string_literal: true

module API
  module V1
    module Users
      module Me
        class Show < Base
          helpers Pundit

          desc "Return the logged in user"
          get do
            authorize current_user, :me?
            render current_user, render_options(context: { endpoint: "users/me" })
          end
        end
      end
    end
  end
end
