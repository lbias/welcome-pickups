# tableless model, to handle driver session logic
class DriverSession
	include ActiveModel::Validations
	include ActiveModel::Conversion
	extend ActiveModel::Naming
  attr_accessor :email, :password, :token

	validates_presence_of :email, :password
	validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  def initialize(email=nil, password=nil)
    @email = email
    @password = password
		# TODO call API to authenticate
  end

  def to_model
    # You will get to_model error, if you don't have this dummy method
  end

  # You need this otherwise you get an error
  def persisted?
    false
  end
end
