require_relative 'base_console_ui'
require_relative '../../controller/route_controller'
require_relative '../../controller/station_controller'
require_relative 'station_ui'

class RouteConsoleUI < BaseConsoleUI
  @stations_buffer = []

  class << self
    def goto_create_route_mode
      puts 'Вы в режиме создания маршрута!'
      return if stop_command_request

      loop do
        clear_station_buffer!
        puts 'Для создания маршрута необходимо установить начальную и конечную станцию'
        stations = StationController.get_stations

        if stations.size < 2
          puts 'Текущего количество станций недостаточно для создания маршрута'
          puts 'Перехожу в режим создания станций'
          StationConsoleUI.goto_create_station_mode
        else
          goto_choose_stations_mode stations
        end

        if RouteController.create_route(*@stations_buffer)
          puts 'Успешно!'
          clear_station_buffer!
        else
          puts 'Что-то пошло не так, попробуйте ещё раз!('
          clear_station_buffer!
        end

        break if stop_command_request
      end
    end

    def goto_chosen_route
      loop do
        puts 'Выберите, пожалуйста, маршрут - для управления станциями'
        routes = RouteController.get_routes
        show_routes routes

        route_serial_number = gets.chomp.to_i

        if validate_serial_number(route_serial_number)
          puts 'Отлично! Маршрут выбран!'
          chosen_route = routes[route_serial_number - 1]
        else
          puts 'Некорректный вариант( Попробуйте заново!'
        end

        break if stop_command_request
      end
    end

    def show_routes(routes)
      routes.each_with_index do |route, index|
        first_station, *_, last_station = route.stations
        puts "#{index + 1}) #{first_station.name} - #{last_station.name}"
      end
    end

    private

    def goto_manage_on_chosen_route(chosen_route)
      puts 'Что планируете выбрать?'
      loop do
        puts '1) Добавить станции'
        puts '2) Удалить станции'
        
        command = gets.chomp

        manage_on_chosen_route_dispatcher command, chosen_route

        break if stop_command_request
      end
    end

    def manage_on_chosen_route_dispatcher(command, chosen_route)
      case command
      when '1' then goto_add_station_to_chosen_route_mode chosen_route
      when '2' then goto_destroy_station_on_chosen_route_mode chosen_route
      end 
    end

    def goto_destroy_station_on_chosen_route_mode(chosen_route)
      loop do
        puts 'Станции, доступные для удаления'
        stations = RouteController.get_intermediate_stations(chosen_route)
        StationConsoleUI.show_stations(stations)

        station_serial_number = gets.chomp.to_i

        if validate_serial_number(stations, station_serial_number)
          station = stations[station_serial_number - 1]
          puts 'Успешно!' if RouteController.destroy_station_on_route(chosen_route, station)
        else
          puts 'Некорректный номер станции - введите, пожалуйста, ещё раз'
        end
      end
    end

    def goto_add_station_to_chosen_route_mode(chosen_route)
      loop do
        puts 'Введите, пожалуйста, название станции'
        name = gets.chomp
        
        unless StationConsoleUI.validate_name_station(name)
          puts 'Название станции не может быть пустым!'
          break if stop_command_request
          redo
        end

        puts 'Успешно!' if RouteController.add_intermediate_station_to_route(chosen_route, name)

        break if stop_command_request
      end
    end

    def goto_choose_stations_mode(stations)
      loop do
        puts 'Текущего количество станций достаточно для создания маршрута'
        puts '1) Выбрать станции из текущего списка?'
        puts '2) Создать новые/новую'
        command = gets.chomp
        already_exist_stations_command_dispatcher(command, stations)

        break if fill_stations_buffer?
      end
    end

    def already_exist_stations_command_dispatcher(command, stations)
      case command
      when '1'
        goto_choose_station_mode stations
      when '2'
        StationConsoleUI.goto_create_station_mode
      else
        puts 'Некорректная команда в обработчике существующих станций('
      end
    end

    def goto_choose_station_mode(stations)
      loop do
        StationConsoleUI.show_stations(stations)
        chosen_station_serial = gets.chomp.to_i
        
        if validate_serial_number(stations, chosen_station_serial)
          puts 'Великолепно!'
          @stations_buffer << stations[chosen_station_serial - 1]
        else
          puts 'Некорректный номер станции - введите, пожалуйста, ещё раз'
        end

        break if fill_stations_buffer?
        break if stop_command_request
      end
    end



    def fill_stations_buffer?
      @stations_buffer.size == 2
    end

    def clear_station_buffer!
      @stations_buffer = []
    end
  end
end