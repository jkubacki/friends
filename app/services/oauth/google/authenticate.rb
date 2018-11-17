# frozen_string_literal: true

module Oauth
  module Google
    class Authenticate < ApplicationService
      def initialize(access_code:)
        @access_code = access_code
      end

      def call
        yield fetch_result = fetch_user_data
        user_data = fetch_result.value!
        user = User.find_by(email: user_emails(user_data[:emails]))
        user ||= create_missing_user(user_data)
        create_social_media_profile(user, user_data[:id])
        Success(user)
      end

      private

      attr_reader :access_code

      def fetch_user_data
        Oauth::Google::FetchUserData.call(access_code: access_code)
      end

      def create_missing_user(user_data)
        Oauth::Google::CreateUser.call(user_data: user_data).value!
      end

      def create_social_media_profile(user, uid)
        SocialMediaProfile.find_or_create_by!(
          user_id: user.id,
          provider: "google",
          uid: uid
        )
      end

      def user_emails(emails)
        emails.map { |em| em[:value] }
      end
    end
  end
end
