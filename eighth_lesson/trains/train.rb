# frozen_string_literal: true
require_relative '../modules/manufacturer'
require_relative '../modules/instance_counter'
require_relative '../modules/validatable'
class Train
  include Manufacturer
  include InstanceCounter
  include Validatable

  INCREASE_SPEED_STEP = 10
  ALLOWED_WAGON_TYPES = %i[].freeze
  TYPE = nil
  NUMBER_FORMAT = /^\w{3}-*\w{2}$/
  attr_reader :current_speed, :number
  
  instances # Инициализируем инстанс переменную класса @instances при загрузке класса

  @@trains = []
  def self.find(number)
    @@trains.find { |train| train.number == number }
  end

  def initialize(number)
    @number = number
    @wagons = []
    @current_speed = 0
    @current_route = nil
    @current_station = nil
    @current_station_index = 0
    validate!
    register_instance
  end

  def wagons
    @wagons.freeze
  end

  def add_wagon(wagon)
    @wagons << wagon if self.class::ALLOWED_WAGON_TYPES.include?(wagon.class::TYPE) && current_speed.zero?
    self
  end

  def unhook_wagon
    @wagons.pop if current_speed.zero?
    self
  end

  def increase_speed
    @current_speed += self.class::INCREASE_SPEED_STEP
    self
  end

  def stop_train
    @current_speed = 0
  end

  def current_route=(route)
    self.current_route = route
    self.current_station = route.stations.first
  end

  def drive_forward
    current_station.send_train(self)
    self.current_station = next_station
  end

  def drive_back
    current_station.send_train self
    self.current_station = previous_station
  end

  def next_station
    return current_station_index if current_station_index == (current_route.stations.size - 1)

    current_route.stations[current_station_index + 1]
  end

  def previous_station
    return current_station_index if current_station_index.zero?

    current_route.stations[current_station_index - 1]
  end

  private

  attr_reader :current_station_index, :current_route
  attr_accessor :current_station
end
