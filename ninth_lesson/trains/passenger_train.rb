# frozen_string_literal: true
require_relative 'train'
class PassengerTrain < Train
  TYPE = :passenger
  ALLOWED_WAGON_TYPES = %i[passenger].freeze

  validate :number, :format, NUMBER_FORMAT
end
