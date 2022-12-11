require_relative 'wagon'

class CargoWagon < Wagon
  
  WAGON_TYPE = :cargo

  attr_reader :volume, :occupied_volume

  def initialize(volume)
    @volume = volume
    @occupied_volume = 0
  end

  def take_volume(volume)
    @occupied_volume += volume if has_free_volume?
  end

  def has_free_volume?
    get_free_volume > 0
  end

  def get_free_volume
    @volume - @occupied_volume
  end
end