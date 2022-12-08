require_relative 'train'
require_relative 'passenger_wagon'

class PassengerTrain < Train
  TRAIN_TYPE = :passenger

  def initialize(number)
    super(number, self.class::TRAIN_TYPE)
  end

  def attach_wagon
    super PassengerWagon.new
  end
end