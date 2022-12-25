# frozen_string_literal: true
require_relative 'modules/accessors'

class Route
  extend Accessors

  def initialize(start_station, end_station)
    @start_station = start_station
    @end_station = end_station
    @intermediate_stations = []
  end

  def each(&block)
    stations.each(&block) if block_given?
  end

  def stations
    [start_station, *intermediate_stations, end_station]
  end

  def add_intermediate_station(station)
    intermediate_stations << station
    self
  end

  def destroy_intermediate_station(target_station)
    self.intermediate_stations = intermediate_stations.reject { |station| station == target_station }
    self
  end

  def to_s
    "#{start_station.name} - #{end_station.name}"
  end

  private

  attr_reader :start_station, :end_station
  attr_accessor_with_history :intermediate_stations
end
