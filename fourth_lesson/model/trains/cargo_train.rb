require_relative 'base_train'

class CargoTrain < BaseTrain
  @train_type = :cargo
  
  class << self
    attr_reader :train_type
  end

  def initialize(number)
    super(number, self.class.train_type)
  end
end