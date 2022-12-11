require_relative 'modules/instance_counter'

class Route
  include InstanceCounter

  attr_reader :name

  # Валидировать тут станции по типу не вижу смысла, так как губим преимущества утиной типизации.ИМХО
  def initialize(starting_station, end_station)
    @starting_station = starting_station
    @end_station = end_station
    @name = "#{starting_station.name}-#{end_station.name}"
    @intermediate_stations = []
    self.register_instance
  end

  def add_intermediate_station(station)
    @intermediate_stations << station
  end

  def destroy_intermediate_station(target_station)
    @intermediate_stations = @intermediate_stations.select { |station| !(station.equal? target_station) }
  end

  def intermediate_stations
    @intermediate_stations.freeze
  end

  # Удалил метод output_station, так как в нём нет смысла.
  # Клиентский код может вызвать метод stations и организовать вывод станций в том формате, в котором он хочет
  def stations
    [@starting_station, @intermediate_stations, @end_station].flatten!
  end
end