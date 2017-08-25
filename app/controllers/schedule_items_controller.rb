class ScheduleItemsController < ApplicationController
  include WelcomePickupsAdapter

  # GET /schedule_items
  def index
    # start the API call to request the schedule
    begin
    	filter_params = proper_date_filters
    	auth_params = current_driver_session.auth_header_hash
      response = request_schedule(filter_params, auth_params)
      if (response[:success])
      	# call is successful, and list of items are returned
    		@schedule = Schedule.new response[:items_hash]
	    	if @schedule.valid?
	    		@schedule.calculate_availability_stats
	    	elsif !@schedule.has_valid_items?
	    		# scheduled items are corrupted
	    		errors = @schedule.errors.full_messages.map{|e| "#{e} ."}.first
	    		flash.now[:error] = "Erros Occured: #{errors}"
	    	end
    	else
    		flash.now[:error] = response[:error]
      end
    rescue WelcomePickupsAdapter::WelcomePickupsException => e
      # something went wrong with the call
      flash.now[:error] = e.message
    end
  end

  private

  def proper_date_filters
  	# convenient default values, to list some items
  	params[:from] = proper_date_or_nil(params[:from]) || 16.months.ago.to_date
  	params[:to] = proper_date_or_nil(params[:to]) || Date.today

    # swap dates if 'from' is after 'to'
    params[:from], params[:to] = params[:to], params[:from] if params[:to] < params[:from]
  end

  # TODO move to util helper
  def proper_date_or_nil date
    date.to_date rescue nil
  end
end
