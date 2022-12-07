require_relative 'base_train'

class PassengerTrain < BaseTrain
  @train_type = :passenger

  class << self
    attr_reader :train_type
  end

  def initialize(number)
    super(number, self.class.train_type)
  end
end