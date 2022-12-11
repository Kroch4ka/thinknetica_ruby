require_relative '../modules/vendorable'
require_relative '../modules/instance_counter'
require_relative '../errors/validation_error'

class Train
  include Enumerable
  include InstanceCounter
  include Vendorable

  attr_reader :speed, :number, :type

  @@trains = []

  INCREASE_STEP = 10
  NUMBER_FORMAT = /^[0-9а-я]{3}-?[0-9а-я]{2}$/i

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
    validate!
    @@trains << self
    self.register_instance
  end

  # Предоставляем возможность при помощи стандартного модуля Enumerable итерироваться по объекту класса
  def each
    block_given? ? @wagons.each { |wagon| yield wagon } : @wagons  
  end

  def move_up
    get_current_station.send_train
    @current_station_index = get_next_station_idx
  end

  def move_down
    get_current_station.send_train
    @current_station_index = get_prev_station_idx
  end

  def get_next_station
    return get_current_station if @current_station_index == @route.stations.size - 1

    return @route.stations[@current_station_index + 1]
  end

  def get_prev_station
    return get_current_station if @current_station_index == 0

    return @route.stations[@current_station_index - 1]
  end

  def get_current_station
    @route.stations[@current_station_index]
  end

  def has_route?
   !!@route
  end
  
  def set_route(route)
    @route = route
    @route.starting_station.add_train self
  end

  def increase_speed
    @speed += self.class::INCREASE_STEP
  end

  def slow_down
    @speed = 0
  end

  def attach_wagon(wagon)
    @wagons << wagon if @speed == 0 && @type == wagon.class::WAGON_TYPE
  end

  def unhook_wagon
    @wagons.pop if @speed == 0
  end

  def valid?
    validate!
    true
  rescue ValidationError
    false
  end

  private

  def validate!
    raise ValidationError.new('Некорректный формат номера поезда, должен быть в формате xxx-xx, где x - цифра или кириллическая буква, тире - не обязательно') if NUMBER_FORMAT !~ @number
  end

  def get_next_station_idx
    return @current_station_index if @current_station_index == @route.stations.size - 1

    return @current_station_index + 1
  end

  def get_prev_station_idx
    return @current_station_index if @current_station_index == 0

    return @current_station_index - 1
  end
end