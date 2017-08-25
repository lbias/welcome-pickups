# tableless model, to handle driver session logic
class DriverSession
	include ActiveModel::Validations
	include ActiveModel::Conversion
	extend ActiveModel::Naming

	# can be authenticated by WelcomePickupsAPI
  include WelcomePickupsAdapter::WelcomePickupsAuthResource

  attr_accessor :email, :password

  # -- Validations

	validates_presence_of :email, :password
	validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

	# -- Initializaiton

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def to_model
    # You will get to_model error, if you don't have this dummy method
  end

  # You need this otherwise you get an error
  def persisted?
    false
  end
end
