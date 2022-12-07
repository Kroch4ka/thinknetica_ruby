class World
  @stations = []
  @trains = []
  @routes = []

  class << self
    attr_reader :stations, :trains, :routes

    def add_station(station)
      @stations << station      
    end

    def add_train(train)
      @trains << train
    end

    def add_route(route)
      @routes << route
    end

    def destroy_station(station)
      @stations = @stations.select { |current_station| !(station.equals? current_station) }
    end
  end
end