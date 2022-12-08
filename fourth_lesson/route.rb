require_relative './station'

class Route
  attr_reader :name

  def initialize(starting_station, end_station)
    @starting_station = starting_station
    @end_station = end_station
    @name = "#{starting_station.name}-#{end_station.name}"
    @intermediate_stations = []
  end

  def add_intermediate_station(station)
    @intermediate_stations << station
  end

  def destroy_intermediate_station(target_station)
    @intermediate_stations = @intermediate_stations.select { |station| !(station.equal? target_station) }
  end

  def output_route
    puts 'List of all stations from start to end: '
    puts @starting_station.name
    @intermediate_stations.each { |station| puts station.name }
    puts @end_station.name
  end

  def intermediate_stations
    @intermediate_stations.freeze
  end

  def stations
    [@starting_station, @intermediate_stations, @end_station].flatten!
  end
end