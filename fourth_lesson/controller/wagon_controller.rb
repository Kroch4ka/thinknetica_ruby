require_relative '../model/wagons/cargo_wagon'
require_relative '../model/wagons/passenger_wagon'

class WagonController
  class << self
    def add_wagon_to_train(train)
      wagon = wagon_by_train_type_builder(train.type)
      train.attach_wagon wagon

      true
    end

    def unhook_wagon_from_train(train)
      train.unhook_wagon

      true
    end

    private

    def wagon_by_train_type_builder(train_type)
      case train_type
      when :passenger then PassengerTrain.new
      when :cargo then CargoPassenger.new
      end
    end
  end
end