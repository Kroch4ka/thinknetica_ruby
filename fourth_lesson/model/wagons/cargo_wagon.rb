require_relative 'base_wagon'

class CargoWagon < BaseWagon
  @wagon_type = :cargo

  class << self
    attr_reader :wagon_type
  end

  def initialize
    super(self.class.wagon_type)
  end
end