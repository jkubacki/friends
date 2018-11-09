# frozen_string_literal: true

module Oauth
  module Google
    class Authenticate < ApplicationService
      def initialize(payload:)
        @payload = payload
      end

      def call
        user = User.find_by(email: user_emails)
        yield user ||= create_missing_user
        provide_social_media_profile(user)
        Success(user)
      end

      private

      attr_reader :payload

      def create_missing_user
        # OAuthServices::Create::CreateUserViaGoogle.call(payload: payload).value!
      end

      def provide_social_media_profile(user)
        # SocialMediaProfile.find_or_create_by!(
        #   user_id: user.id,
        #   provider: "google",
        #   uid: payload["uid"]
        # )
      end

      def user_emails
        payload["emails"].map { |em| em[:value] }
      end
    end
  end
end
