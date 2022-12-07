require_relative '../model/world'
require_relative '../model/route'
require_relative '../model/station'

class RouteController
  class << self
    def create_route(*stations)
      validate_start_stations(*stations) && World.add_route(Route.new(stations.first, stations.last))
    end

    def add_intermediate_station_to_route(route, station_name)
      route.add_intermediate_station(Station.new(station_name))
      true
    end

    def get_intermediate_stations(route)
      route.intermediate_stations.freeze
    end

    def get_routes
      World.routes.freeze
    end

    def destroy_station_on_route(route, station)
      route.destroy_intermediate_station(station)
      true
    end

    private

    def validate_start_stations(*stations)
      stations.size == 2 && !(stations.first.equal? stations.last)
    end
  end
end