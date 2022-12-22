# frozen_string_literal: true
require_relative 'modules/validatable'
class Station
  include Validatable

  NAME_FORMAT = /^[a-zа-я]{4,20}$/i

  attr_reader :name

  check :name, NAME_FORMAT

  @@instances = []
  def self.all
    @@instances.freeze
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
    @@instances << self
  end

  def trains
    @trains.freeze
  end

  def send_train(target_train)
    @trains = trains.reject { |train| train == target_train }
  end

  def add_train(train)
    @trains << train
    self
  end

  def trains_by_type(type)
    trains.select { |train| train.class::TYPE == type }
  end

  private

  attr_writer :trains
end
