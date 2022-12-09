require_relative '../route'
require_relative '../modules/vendorable'
require_relative '../modules/instance_counter'

class Train
  include InstanceCounter
  include Vendorable

  attr_reader :speed, :number_of_wagons, :number

  @@trains = []
  INCREASE_STEP = 10

  def self.find(number)
    @@trains.find { |train| train.number == number }
  end

  def initialize(number, type)
    @number = number
    @type = type
    @wagons = []
    @speed = 0
    @route = nil
    @current_station_index = 0
    @@trains << self
    self.register_instance
  end

  def move_up
    @current_station.send_train
    @current_station = get_next_station
  end

  def move_down
    @current_station.send_train
    @current_station = get_prev_station
  end

  def get_next_station(target_station)
    return target_station if @current_station_index == get_stations_of_current_route.size - 1

    return get_stations_of_current_route[@current_station_index + 1]
  end

  def get_prev_station(target_station)
    return target_station if @current_station_index == 0

    return get_stations_of_current_route[@current_station_index + 1]
  end

  def get_current_station
    @current_station
  end

  def has_route?
   !!@route
  end
  
  def set_route(route)
    @route = route
    @route.starting_station.add_train self
    @current_station = @route.starting_station
  end

  def increase_speed
    @speed += self.class::INCREASE_STEP
  end

  def slow_down
    @speed = 0
  end

  def attach_wagon(wagon)
    @wagons << wagon if @speed == 0 && @type == wagon.class::TRAIN_TYPE
  end

  def unhook_wagon
    @wagons.pop if @speed == 0
  end
end