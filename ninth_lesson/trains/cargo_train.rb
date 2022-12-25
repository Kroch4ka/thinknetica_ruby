# frozen_string_literal: true
require_relative 'train'

class CargoTrain < Train
  TYPE = :cargo
  ALLOWED_WAGON_TYPES = %i[cargo].freeze

  validate :number, :format, NUMBER_FORMAT
end
