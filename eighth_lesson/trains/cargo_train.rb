# frozen_string_literal: true
require_relative 'train'

class CargoTrain < Train
  TYPE = :cargo
  ALLOWED_WAGON_TYPES = %i[cargo].freeze

  check :number, NUMBER_FORMAT
end
