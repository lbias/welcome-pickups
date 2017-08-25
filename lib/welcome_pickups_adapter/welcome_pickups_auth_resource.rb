module WelcomePickupsAdapter
  # this module has the logic related to authenticating resource with WelcomePickupsAPI
  module WelcomePickupsAuthResource
    extend ActiveSupport::Concern

    attr_accessor :attempt_counter, :token

    def authenticated?
      token.present?
    end

    def to_auth_hash
      {
        email: email,
        password: password,
        attempt_counter: attempt_counter || '1'
      }
    end

    def auth_header_hash
      {
        email: email,
        token: token
      }
    end

  end

end
