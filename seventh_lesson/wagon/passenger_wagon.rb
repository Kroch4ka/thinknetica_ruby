require_relative 'wagon'

class PassengerWagon < Wagon
  WAGON_TYPE = :passenger

  def initialize(total_seats)
    super total_seats
  end

  def take_place
    @occupied_volume += 1 if @volume - @occupied_volume > 0
  end
end