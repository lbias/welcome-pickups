module ApiAuthHelper

  def get_valid_auth_header

    auth_params = {email: 'savvas@dopios.com', password: 'Accounts12', attempt_counter: '1'}
    response = authenticate_driver_session(auth_params)

    { email: 'savvas@dopios.com',
        token: response[:token] }
  end
end
