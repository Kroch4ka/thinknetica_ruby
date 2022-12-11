require_relative 'train'

class CargoTrain < Train
  TRAIN_TYPE = :cargo

  def initialize(number)
    super(number, self.class::TRAIN_TYPE)
  end
end