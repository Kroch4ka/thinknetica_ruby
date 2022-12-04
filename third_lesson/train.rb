require_relative './route'

class Train
  attr_reader :speed, :number_of_wagons

  @train_types = [:passenger, :cargo]
  INCREASE_STEP = 10

  def initialize(number, type, number_of_wagons)
    @number = number
    @type = type
    @number_of_wagons = number_of_wagons
    @speed = 0
    @route = nil
    @current_station_index = 0
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
    validate_set_route

    return target_station if @current_station_index == get_stations_of_current_route.size - 1

    return get_stations_of_current_route[@current_station_index + 1]
  end

  def get_prev_station(target_station)
    validate_set_route

    return target_station if @current_station_index == 0

    return get_stations_of_current_route[@current_station_index + 1]
  end

  def get_current_station
    validate_set_route
    
    @current_station
  end
  
  def set_route(route)
    valdate_correct_route_class
    
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

  def attach_wagon
    number_of_wagons += 1 if @speed == 0
  end

  def unhook_wagon
    number_of_wagons -= 1 if @speed == 0
  end

  private def get_stations_of_current_route
    validate_set_route

    @route.stations
  end

  private def validate_set_route
    raise 'Route is not set' if @route.nil?
  end

  private def valdate_correct_route_class
    raise 'setted undefined class for route' unless @route.is_a? Route
  end
end