require_relative '../model/world'
require_relative '../model/trains/passenger_train'
require_relative '../model/trains/cargo_train'

class TrainController
  class << self
    def get_train_types
      [PassengerTrain.train_type, CargoTrain.train_type]
    end

    def get_trains
      Word.trains
    end

    def move_up(train)
      train.move_up

      true
    end

    def move_down(train)
      trian.move_down

      true
    end

    def create_train(number, type)
      return false unless validate_train_type(type)
      
      return train_builder(number, type)
    end

    def set_route_to_train(train, route)
      train.set_route route
    end

    private

    def validate_train_type(type)
      return false unless type.is_a? Symbol
      return false unless get_train_types.include? type

      true
    end

    def train_builder(number, type)
      case type
      when PassengerTrain.train_type then return PassengerTrain.new(number) 
      when CargoTrain.train_type then return CargoTrain.new(number)
      end
    end
  end
end