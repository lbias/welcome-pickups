module WelcomePickupsAdapter
  include HTTParty

  # only communication point with WelcomePickups API
  def remote_action(method, server_url, action_url, action_params = {}, httparty_options = {})
    begin
      options = {:headers => { 'Content-Type' => 'application/json' }}
      options[:body] = action_params.to_json if action_params.present?
      options[:timeout] = 5
      # options.merge!(httparty_options)
      options = safe_merge options, httparty_options

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
      'X-User-Email' => auth_params[:email],
      'X-User-Token' => auth_params[:token]
     }
    httparty_options = safe_merge httparty_options, {headers: auth_headers}

    remote_action(method, server_url, action_url, action_params, httparty_options)
  end

  # All API calls to be listed here

  # authenticate resource
  # Api Doc: http://crm.welcomepickups.com/apipie/1.0/drivers_appapiv1authentications/login.html
  # example:
  #   auth_params = {email: 'savvas@dopios.com', password: 'Accounts12', attempt_counter: '1'}
  #
  def authenticate_driver_session(auth_params)
    response = remote_action("post", nil, 'login', auth_params).parsed_response
    # TODO add utils to parse response based on API documentaion
    if response['token'].present?
      {  success: true,
        token: response['token'] }
    else
      {  success: false,
        attempt_counter: response['attempt_counter'],
        error: response['result'] }
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

    # TODO add utils to parse response based on API documentaion
    case response.code
      when 200
        { success: true,
          items_hash: response.parsed_response}
      when 400
        { success: false,
          error: response.parsed_response["result"]}
      when 401
        { success: false,
          error: response.parsed_response["error"]}
      else
        { success: false,
          error: 'Sorry! Something went wrong with WelcomePickups API, please contact administration!'}
    end
  end

  private
  # TODO add utils to parse response based on API documentaion

  # merge inner hashes without overriding them
  def safe_merge h1, h2
    h1.merge(h2) {|key, first, second| first.is_a?(Hash) && second.is_a?(Hash) ? first.merge(second) : second }
  end

end
