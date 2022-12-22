# frozen_string_literal: true
require_relative '../modules/manufacturer'
class Wagon
  include Manufacturer

  TYPE = nil

  attr_reader :total_volume, :occupied_volume

  def initialize(total_volume)
    @total_volume = total_volume
    @occupied_volume = 0
  end

  def take_volume(volume)
    @occupied_volume += volume if enough_space_for_fill?
  end

  def free_volume
    @total_volume - @occupied_volume
  end

  def enough_space_for_fill?(volume)
    free_volume - volume >= 0
  end
end
