# frozen_string_literal: true

require_relative 'wagon'
class PassengerWagon < Wagon
  TYPE = :passenger
  TAKEN_SEATS_FOR_STEP = 1
  def take_volume
    super TAKEN_SEATS_FOR_STEP
  end
end
