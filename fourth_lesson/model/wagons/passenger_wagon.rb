require_relative 'base_wagon'

class PassengerWagon < BaseWagon
  @wagon_type = :passenger

  class << self
    attr_reader :wagon_type
  end

  def initialize
    super(self.class.wagon_type)
  end
end