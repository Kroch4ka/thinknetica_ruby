# frozen_string_literal: true
require_relative 'state'
require_relative '../trains/passenger_train'
require_relative '../trains/cargo_train'
require_relative '../route'
require_relative '../station'
module Fixtures
  extend State

  class << self
    def prepare
      cargo_train = CargoTrain.new '123'
      passenger_train = PassengerTrain.new '123-45'
      first_station = Station.new 'Алексеевская'
      first_station.add_train cargo_train
      second_station = Station.new 'Александровская'
      second_station.add_train passenger_train
      route = Route.new(first_station, second_station)
      routes << route
      trains << cargo_train << passenger_train
      stations << first_station << second_station
    end
  end
end
