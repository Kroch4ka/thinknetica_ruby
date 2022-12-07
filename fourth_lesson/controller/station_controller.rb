require_relative '../model/world'
require_relative '../model/station'

class StationController
  class << self
    def create_station(name)
      World.add_station(Station.new(name))
      true
    end

    def get_stations
      World.stations
    end
  end
end