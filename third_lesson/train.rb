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
    @current_station = nil
  end

  def move_up
    @current_station.send_train
    @current_station = get_next_station @current_station
  end

  def move_down
    @current_station.send_train
    @current_station = get_prev_station @current_station
  end

  def get_next_station(target_station)
    raise 'Route is not set' if @route.nil?

    stations = @route.stations

    return target_station if stations.last.equal? target_station

    stations.each_with_index do |station, idx|
      if station.equal? target_station
        return stations[idx + 1]
      end
    end
  end

  def get_prev_station(target_station)
    raise 'Route is not set' if @route.nil?

    stations = @route.stations

    return target_station if stations.first.equal? target_station

    stations.each_with_index do |station, idx|
      if station.equal? target_station
        return stations[idx - 1]
      end
    end
  end

  def get_current_station
    raise 'Route is not set' if @route.nil?
    
    @current_station
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

  def attach_wagon
    number_of_wagons += 1 if @speed == 0
  end

  def unhook_wagon
    number_of_wagons -= 1 if @speed == 0
  end
end