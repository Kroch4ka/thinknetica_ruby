# frozen_string_literal: true
require_relative '../station'
require_relative 'base_ui'
require_relative '../trains/cargo_train'
class StationUi < BaseUI
  def self.create_station
    puts 'Добро пожаловать в режим создания станции!'
    print 'Название станции: '
    name = gets.chomp
    puts 'Успешно!' if stations << Station.new(name)
    clear_console
  end

  def self.show_stations
    puts 'Вы в режиме просмотра станций!'
    station = choose_variant(stations, &:name)
    if station.trains.empty?
      puts 'На данный момент на станции нет поездов)'
      return
    end
    draw_numbered_list(station.trains, &:number)
    sleep 1
    clear_console
  end
end