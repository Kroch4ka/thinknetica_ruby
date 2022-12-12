require_relative 'wagon'

class CargoWagon < Wagon
  
  WAGON_TYPE = :cargo

  def initialize(volume)
    super volume
  end

  def take_volume(volume)
    @occupied_volume += volume if @volume - @occupied_volume >= volume
  end
end