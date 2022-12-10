class ValidationError < StandardError
  def initialize(message = "Something went wrong!")
    super message
  end
end