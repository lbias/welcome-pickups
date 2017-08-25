# tableless model, to handle driver session logic
class DriverSession
	extend ActiveModel::Naming
  attr_accessor :email, :password, :token

  def initialize(email=nil, password=nil)
    @email = email
    @password = password
  end

  def to_model
    # You will get to_model error, if you don't have this dummy method
  end

  # You need this otherwise you get an error
  def persisted?
    false
  end
end
