require_relative '../modules/vendorable'

class Wagon
  include Vendorable

  attr_reader :volume, :occupied_volume

  def initialize(volume)
    @volume = volume
    @occupied_volume = 0
  end

  def get_free_volume
    @volume - @occupied_volume
  end

  def has_free_volume?
    get_free_volume > 0
  end
end