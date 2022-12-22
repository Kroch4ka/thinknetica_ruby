# frozen_string_literal: true

class Station
  include Enumerable

  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def trains
    @trains.freeze
  end

  def each(&block)
    trains.each(&block) if block_given?
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
