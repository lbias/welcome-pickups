module WelcomePickupsAdapter
  include HTTParty

  # only communication point with WelcomePickups API
  def remote_action(method, server_url, action_url, action_params = {}, httparty_options = {})
    begin
      options = {:headers => { 'Content-Type' => 'application/json' }}
      options[:body] = action_params.to_json if action_params.present?
      options[:timeout] = 5
      options.merge!(httparty_options)

      server_url ||= 'crm.welcomepickups.com/drivers-app/api/v1/'
      url = URI.encode "http://#{server_url}#{action_url}"
      HTTParty.send(method, URI(url), options)

    rescue Errno::ECONNREFUSED => e
      Rails.logger.error e.message
      raise WelcomePickupsException.new("Can't connect to WelcomePickups, Connection refused.")
    rescue Errno::ETIMEDOUT => e
      Rails.logger.error e.message
      raise WelcomePickupsException.new("Can't connect to WelcomePickups, Connection Timeout.")
    rescue  Timeout::Error => e
      Rails.logger.error e.message
      raise WelcomePickupsException.new("Can't connect to WelcomePickups, Connection Timeout.")
    rescue Exception => e
      Rails.logger.error e.message
      raise WelcomePickupsException.new("Something went wrong with WelcomePickups API. It failed with this message \n\t'#{e.message}'")
    end
  end

  # only authenticated communication point with WelcomePickups API
  def remote_authed_action(auth_params, method, server_url, action_url, action_params = {}, httparty_options = {})
    auth_headers = {
      'X-User-Email' => auth_params.email,
      'X-User-Token' => auth_params.token
     }
     httparty_options.merge!({headers: auth_headers})

    remote_action(method, server_url, action_url, action_params, httparty_options)
  end

  # All API calls to be listed here

  # authenticate resource
  # Api Doc: http://crm.welcomepickups.com/apipie/1.0/drivers_appapiv1authentications/login.html
  # example:
  #   auth_params = {email: 'savvas@dopios.com', password: 'Accounts12', attempt_counter: 1}
  #
  def authenticate_driver_session(auth_params)
    response = remote_action("post", nil, 'login', auth_params).parsed_response
    if response['token'].present?
      {
        success: true,
        token: response['token']
      }
    else
      {
        success: false,
        attempt_counter: response['attempt_counter'],
        error: response['result']
      }
    end
  end

  # request schedule
  # API Doc: http://crm.welcomepickups.com/apipie/1.0/drivers_appapiv1accounts/schedule.html
  # example:
  #   filter_params = {from_date: '2016-01-01', to_date: '2016-12-31'}
  #   auth_params = {email: 'savvas@dopios.com', token: '1aMdXpWH7vsbUwfcXnjr'}
  #
  def request_schedule(filter_params, auth_params)
    response = remote_authed_action(auth_params, "get", nil, 'account/schedule', filter_params)
  end

end
