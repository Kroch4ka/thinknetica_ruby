# frozen_string_literal: true
require_relative '../station'
require_relative 'base_ui'
require_relative '../trains/cargo_train'
require_relative '../errors/validation_error'
require_relative 'train_ui'
class StationUi < BaseUI
  def self.create_station
    print 'Название станции: '
    name = gets.chomp
    puts 'Успешно!' if stations << Station.new(name)
  rescue ValidationError => e
    puts e.message
    puts 'Заново!'
    retry
  end

  def self.show_stations
    station = choose_variant(stations, &:name)
    if station.trains.empty?
      puts 'На данный момент на станции нет поездов)'
      return
    end
    draw_numbered_list(station.trains) do |train|
      number = train.number
      type = TrainUI.train_types[train.class::TYPE][:name]
      count_wagons = train.wagons.size
      "Номер поезда: #{number}, тип: #{type}, кол-во вагонов: #{count_wagons}."
    end
  end
end