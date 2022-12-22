# frozen_string_literal: true
require_relative 'base_ui'
require_relative 'station_ui'
require_relative '../route'
class RouteUI < BaseUI
  def self.create_route
    puts 'Добро пожаловать в режим создания маршрута!'
    puts 'У Вас нет созданных станций!' if stations.empty?
    if stations.size < 2
      needed_stations = 2 - stations.size
      puts "Для создания станции - нужно по-крайней мере 2 свободных. Нужно ещё #{needed_stations}."
      return
    end
    puts 'Выберите начальную станцию из предложенных!'
    start_station = choose_variant(stations, &:name)
    puts 'Выберите конечную станцию из предложенных!'
    end_station = choose_variant(stations, &:name)
    puts 'Успешно!' if routes << Route.new(start_station, end_station)
  end

  def self.manage_routes
    puts 'Добро пожаловать в режим управления маршрутами!'
    if routes.empty?
      puts 'Нет ни одного созданного маршрута!'
      return
    end
    puts 'Выберите один из вариантов маршрутов: '
    managed_route = choose_variant(routes, &:to_s)
    puts 'Выберите одно из действий: '
    chosen_action = choose_variant(manage_actions.keys)
    send(manage_actions[chosen_action], managed_route)
  end

  private_class_method def self.manage_actions
    {
      'Добавить' => :add_station_to_route,
      'Удалить' => :destroy_station_on_route
    }
  end

  private_class_method def self.add_station_to_route(route, station)
    puts 'Выберите одну из станций: '
    chosen_station = choose_variant(route.stations, &:name)
    puts 'Успешно' if route.add_intermediate_station chosen_station
  end

  private_class_method def self.destroy_station_on_route(route)
    puts 'Выберите одну из станций: '
    chosen_station = choose_variant(route.stations, &:name)
    puts 'Успешно' if route.destroy_intermediate_station chosen_station
  end
end