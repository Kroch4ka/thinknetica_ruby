require_relative 'train'
require_relative 'cargo_wagon'

class CargoTrain < Train
  TRAIN_TYPE = :cargo

  def initialize(number)
    super(number, self.class::TRAIN_TYPE)
  end

  def attach_wagon
    super CargoWagon.new
  end
end