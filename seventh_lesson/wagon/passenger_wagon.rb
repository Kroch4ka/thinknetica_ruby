require_relative 'wagon'

class PassengerWagon < Wagon
  WAGON_TYPE = :passenger

  attr_reader :total_seats, :total_occupied

  def initialize(total_seats)
    @total_seats = total_seats
    @total_occupied_seats = 0
  end

  def take_the_place
    @total_occupied_seats += 1 if has_empty_seats?
  end

  def has_empty_seats?
    get_empty_seats > 0
  end

  def get_empty_seats
    @total_seats - @total_occupied_seats
  end
end